from typing import Dict
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_google_genai import ChatGoogleGenerativeAI
from sqlmodel import Session
from langchain_core.tools import tool, BaseTool

from app.services.avistamiento import get_all_avist
from app.services.noticias import get_all_noticias


def build_tools(session: Session) -> Dict[str, BaseTool]:
    @tool
    def get_avistamientos_info() -> str:
        """
        Obtiene información sobre todos los avistamientos registrados.
        :return: Descripción de los avistamientos
        :rtype: str
        """
        avistamientos = get_all_avist(session)
        if not avistamientos:
            return "No hay avistamientos registrados."
        result = "Lista de avistamientos:\n"
        for avist in avistamientos:
            result += f"- ID: {avist.id}, Descripción: {avist.description}, Coordenadas: latitud={avist.latitud}, longitud={avist.longitud}, Fecha: {avist.detected_at}\n"
        return result

    @tool
    def get_latest_news() -> str:
        """
        Obtiene las últimas noticias relacionadas con avistamientos.
        :return: Descripción de las noticias
        :rtype: str
        """

        noticias = get_all_noticias(session)
        if not noticias:
            return "No hay noticias registradas."
        result = "Últimas noticias:\n"
        for noticia in noticias:
            result += f"- Título: {noticia.title}, Resumen: {noticia.content}\n"
        return result

    return {
        "get_avistamientos_info": get_avistamientos_info,
        "get_latest_news": get_latest_news,
    }


def ask_question(question: str, session: Session) -> dict:
    # System template
    system_prompt = (
        "Eres un asistente de IA que responde acerca de temas relacionados con la detección del murcielago vampiro (desmodus rotundus)."
        "Usa las herramientas disponibles cuando sean útiles. "
        "Si se necesita una herramienta, llámala con los argumentos correctos."
    )

    # Bind model + tools
    tools = build_tools(session)
    model = ChatGoogleGenerativeAI(model="gemini-2.5-flash", temperature=0).bind_tools(
        list(tools.values())
    )

    # --- STEP 1: initial model call ---
    messages = [SystemMessage(content=system_prompt), HumanMessage(content=question)]

    ai_msg = model.invoke(messages)
    messages.append(ai_msg)

    # --- STEP 2: execute all tool calls ---
    results = []
    if ai_msg.tool_calls:
        for call in ai_msg.tool_calls:
            # e.g. [{'name': 'get_weather', 'args': {'location': 'Boston'}, 'id': 'fb91e46d-e3f7-445b-a62f-50ae024bcdac', 'type': 'tool_call'}]

            tool_func = tools[call["name"]]
            tool_result = tool_func.invoke(call["args"])

            messages.append(tool_result)
            results.append(
                {
                    "tool": call["name"],
                    "args": call["args"],
                    "output": tool_result,
                }
            )

        # --- STEP 3: final response ---
        final_response = model.invoke(messages)
    else:
        final_response = ai_msg

    return {
        "response": final_response.content,
        "tool_calls": ai_msg.tool_calls,
        "tool_results": results,
        "usage": final_response.usage_metadata,
        "model": final_response.response_metadata.get("model_name"),
    }
