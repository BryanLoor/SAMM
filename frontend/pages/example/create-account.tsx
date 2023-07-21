import React, { useContext, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/router";
import Image from "next/image";
import { Alert, AlertColor, AlertTitle } from "@mui/material";
import { GithubIcon, TwitterIcon } from "icons";
import {
  Input,
  Label,
  Button,
  WindmillContext,
} from "@roketid/windmill-react-ui";
import { post } from "utils/services/api";

function CrateAccount() {
  const { mode } = useContext(WindmillContext);
  const imgSource =
    mode === "dark"
      ? "/assets/img/create-account-office-dark.jpeg"
      : "/assets/img/create-account-office.jpeg";

  const router = useRouter();

  // State variables for form inputs
  const [fullName, setFullName] = useState("");
  const [lastName, setLastName] = useState("");
  const [idNumber, setIdNumber] = useState("");
  const [usuario, setUsuario] = useState("");
  const [email, setEmail] = useState("");
  const [phoneNumber, setPhoneNumber] = useState("");
  const [password, setPassword] = useState("");
  const [alert, setAlert] = useState({
    type: "",
    title: "",
  });

  // Form submission handler
  const handleSubmit = (e: any) => {
    e.preventDefault();

    // Perform any necessary validation

    // Create a payload object with the form data
    const payload = {
      nombre: fullName,
      apellido:lastName,
      cedula:idNumber,
      tipoIde:'CED',
      Correo_Domicilio:email,
      Cel_Personal:phoneNumber,
      contrasenia:password,
      usuario:usuario
    };
    //send as a form data
    const formData = new FormData();
    formData.append("nombre", fullName);
    formData.append("apellido", lastName);
    formData.append("cedula", idNumber);
    formData.append("tipoIde", "CED");
    formData.append("correo", email);
    formData.append("Cel_Personal", phoneNumber);
    formData.append("contrasenia", password);
    formData.append("usuario", usuario);
    formData.append("rol","4")

    // Do something with the payload (e.g., send it to the server)
    const registro = async () => {
      try{
        const response = await post("/login/registerTemp", formData);
        console.log(response);
        setAlert({
          type: "success",
          title: "Registro exitoso",
        });
        router.push("/example/confirm-account");
      }catch(error:any){
        console.log(error);
        setAlert({
          type: "error",
          title: error.response.data.message,
        });
      }
    };
    registro();
    // Navigate to the next page
    
  };

  return (
    <div className="flex items-center min-h-screen p-6 bg-gray-50 dark:bg-gray-900">
      <div className="flex-1 h-full max-w-xl mx-auto overflow-hidden bg-white rounded-lg shadow-xl dark:bg-gray-800">
        <div className="flex flex-col overflow-y-auto md:flex-row">
          <main className="flex items-center justify-center p-6 sm:p-12 md:w-2/2">
            <div className="w-full">
              <h1 className="mb-4 text-xl font-semibold font-sans text-[#001554] dark:text-gray-200">
                Registro datos
              </h1>
              {alert.type && (
                <Alert severity={alert.type as AlertColor}>
                  <AlertTitle>{alert.title}</AlertTitle>
                </Alert>
              )}
              <form onSubmit={handleSubmit}>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554]">
                    Nombres completos
                  </span>
                  <Input
                    className="mt-1"
                    value={fullName}
                    onChange={(e) => setFullName(e.target.value)}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554]">
                    Apellidos completos
                  </span>
                  <Input
                    className="mt-1"
                    value={lastName}
                    onChange={(e) => setLastName(e.target.value)}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554]">
                    Cédula de identidad
                  </span>
                  <Input
                    className="mt-1"
                    value={idNumber}
                    onChange={(e) => setIdNumber(e.target.value)}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554]">
                    Correo electrónico
                  </span>
                  <Input
                    className="mt-1"
                    type="email"
                    placeholder="john@doe.com"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554]">
                    Número de celular
                  </span>
                  <Input
                    className="mt-1"
                    value={phoneNumber}
                    onChange={(e) => setPhoneNumber(e.target.value)}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554]">
                    Usuario
                  </span>
                  <Input
                    className="mt-1"
                    value={usuario}
                    onChange={(e) => setUsuario(e.target.value)}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554]">Contraseña</span>
                  <Input
                    className="mt-1"
                    placeholder="***************"
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                  />
                  <p className="opacity-75 text-[#001554]">
                    *Recuerda que debe tener 8 caracteres mínimo, una letra en
                    mayúscula, un símbolo y número.
                  </p>
                </Label>
                <button
                  type="submit"
                  className="bg-[#297DE2] hover:bg-blue-600 text-white font-semibold font-sans w-full py-2 px-4 mt-8 rounded"
                >
                  Siguiente
                </button>
              </form>
            </div>
          </main>
        </div>
      </div>
    </div>
  );
}

export default CrateAccount;