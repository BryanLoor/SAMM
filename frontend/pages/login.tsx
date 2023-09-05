import React, { useContext, useState } from "react";
import Link from "next/link";
import Image from "next/image";
import {
  Label,
  Input,
  Button,
  WindmillContext,
} from "@roketid/windmill-react-ui";
import { Alert, AlertColor, AlertTitle } from "@mui/material";
import { useRouter } from "next/router";
import { get, post } from "utils/services/api";
import { BiShow, BiHide } from "react-icons/bi";

// interface UserAuth {
//   apellidos: string;
//   codigo: string;
//   descripcion: string;
//   estado: string;
//   nombres:
// }

function LoginPage() {
  const { mode } = useContext(WindmillContext);
  const router = useRouter();
  const imgSource =
    mode === "dark" ? "/assets/img/SAMM.png" : "/assets/img/SAMM.png";

  const [codigo, setCodigo] = useState("");
  const [clave, setClave] = useState("");
  const [showClave, setShowClave] = useState(false);
  const [alert, setAlert] = useState({
    type: "",
    title: "",
  });

  const toggleClaveVisibility = () => {
    setShowClave((prev) => !prev);
  };

  const handleSubmit = async (e: any) => {
    e.preventDefault();
    setAlert({
      type: "",
      title: "",
    });
    if (!codigo || !clave) {
      setAlert({
        type: "error",
        title: "Por favor ingresa tus credenciales",
      });
      return;
    }

    try {
      const response = await post("/login/login", {
        Codigo: codigo,
        Clave: clave,
        web: true,
      });
      const usuauth = response as {
        apellidos: string;
        codigo: string;
        descripcion: string;
        estado: string;
        nombres: string;
        access_token: string;
      };
      localStorage.setItem("userAuth", JSON.stringify(response));
      const user = localStorage.getItem("userAuth");
      if (user === null) {
      } else {
        localStorage.setItem("jwtToken", usuauth.access_token);
      }

      const getMenu = await get("/menu/getMenu/WEB");

      localStorage.setItem("menu", JSON.stringify(getMenu));
      // TODO: Handle successful login, e.g., redirect to a dashboard page
      console.log("Login successful");
      setAlert({
        type: "success",
        title: "Bienvenido",
      });
      router.push("/welcome");
    } catch (error: any) {
      // TODO: Handle login error
      console.error("Credenciales incorrectas", error);
      setAlert({
        type: "error",
        title: error.response.data.message,
      });
    }
  };

  return (
    <div className="flex items-center min-h-screen p-6 bg-gray-100 dark:bg-gray-900">
      <div className="flex-1 h-full max-w-4xl mx-auto overflow-hidden bg-white rounded-lg shadow-xl dark:bg-gray-800">
        <div className="flex flex-col overflow-y-auto md:flex-row">
          <div className="relative h-32 md:h-auto md:w-1/2 grid justify-center items-center">
            <Image
              aria-hidden="true"
              src={imgSource}
              alt="Office"
              width={200}
              height={200}
            />
          </div>
          <main className="flex items-center justify-center p-6 sm:p-12 md:w-1/2">
            <div className="w-full">
              {alert.title != "" && (
                <Alert severity={alert.type as AlertColor} className="mb-4">
                  <AlertTitle>{alert.title}</AlertTitle>
                </Alert>
              )}
              <h1 className="mb-4 text-xl font-semibold font-sans text-[#001554] dark:text-gray-200">
                Ingresa tu usuario y contraseña.
              </h1>
              <Label>
                <span className="text-[#001554] font-sans">Usuario</span>
                <Input
                  className="mt-1"
                  type="email"
                  placeholder="Escribe tu usuario"
                  value={codigo}
                  onChange={(e) => setCodigo(e.target.value)}
                />
              </Label>

              <Label className="mt-4">
                <span className="text-[#001554] font-sans">Contraseña</span>
                <div style={{ position: "relative", display: "flex" }}>
                  <Input
                    className="mt-1"
                    type={showClave ? "text" : "password"}
                    placeholder="******"
                    value={clave}
                    onChange={(e) => setClave(e.target.value)}
                  />
                  <Button
                    type="button"
                    onClick={toggleClaveVisibility}
                    style={{
                      position: "absolute",
                      right: 0,
                      top: 0,
                      height: "35px",
                      backgroundColor: "transparent",
                      color: "gray",
                      outline: "none",
                      border: "none",
                      marginTop: "5px",
                    }}
                  >
                    {showClave ? <BiHide /> : <BiShow />}
                  </Button>
                </div>
              </Label>

              {/* <p className="mb-4 mt-2 flex justify-end">
                <Link href="/example/forgot-password" legacyBehavior>
                  <a className="text-sm font-sans text-[#1B147A] dark:text-purple-400 hover:underline">
                    ¿Olvidaste tu correo y/o contraseña?
                  </a>
                </Link>
              </p> */}

              <button
                className="bg-[#297DE2] font-sans hover:bg-blue-600 text-white font-bold w-full py-2 px-4 rounded"
                onClick={handleSubmit}
                style={{ marginTop: "25px" }}
              >
                Iniciar sesión
              </button>

              <hr className="my-8" />

              {/* <p className="mt-1">
                <Link href="/example/create" legacyBehavior>
                  <a className="text-sm font-sans text-[#297DE2] dark:text-purple-400 hover:underline">
                    ¿No tienes una cuenta?{" "}
                    <span className="text-[#1B147A]">Regístrate.</span>
                  </a>
                </Link>
              </p> */}
            </div>
          </main>
        </div>
      </div>
    </div>
  );
}

export default LoginPage;
