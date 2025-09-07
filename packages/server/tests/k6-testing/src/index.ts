import avistTesting from "./tests/avist.ts";
import noticiasTesting from "./tests/noticias.ts";
import ubigeosTesting from "./tests/ubigeos.ts";
import usersTesting from "./tests/users.ts";
import docsTesting from "./tests/docs.ts";

export const options = {
  vus: 10,
  duration: "30s",
};

export default function () {
  avistTesting();
  noticiasTesting();
  ubigeosTesting();
  usersTesting();
  docsTesting();
}
