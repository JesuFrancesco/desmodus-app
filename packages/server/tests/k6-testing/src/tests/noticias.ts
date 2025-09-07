import http from "k6/http";
import { sleep, check } from "k6";
import Config from "../config.ts";

export default function () {
  const endpoint = `${Config.apiUrl}/noticias`;

  let res = http.get(endpoint);
  check(res, { "status is 200": (res) => res.status === 200 });
  sleep(1);
}
