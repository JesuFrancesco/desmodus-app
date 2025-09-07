import http from "k6/http";
import { sleep, check } from "k6";
import Config from "../config.ts";

export default function () {
  const endpoint1 = `${Config.apiUrl}/departamento`;
  const endpoint2 = `${Config.apiUrl}/provincia`;
  const endpoint3 = `${Config.apiUrl}/distrito`;

  [endpoint1, endpoint2, endpoint3].forEach((endpoint) => {
    let res = http.get(endpoint);
    check(res, { "status is 200": (res) => res.status === 200 });
    sleep(1);
  });
}
