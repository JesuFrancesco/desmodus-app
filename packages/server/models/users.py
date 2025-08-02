from sqlmodel import Field, Column, String, ForeignKey, SQLModel


class Users(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True, nullable=False)
    name: str = Field(index=True)
    email: str = Field(index=True)
    phone: str = Field(index=True)
    dni: str = Field(index=True, max_length=8)

    distrito_id: str = Field(
        default=None, sa_column=Column(String, ForeignKey("distritos.id"))
    )
