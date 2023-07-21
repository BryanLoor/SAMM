import { Input, Label } from "@roketid/windmill-react-ui";
import Link from "next/link";
import React from "react";
import { post } from "utils/services/api";

const ConfirmAccount = () => {
  const [email, setEmail] = React.useState("");
  function handleResetPassword() {
    if(email == ""){
      alert("Ingrese su correo electrónico");
    }else{
      alert("Se ha enviado un código de verificación a su correo electrónico")   
    // Do something with the payload (e.g., send it to the server)
    const payload = {
      email,
    };
    const sendEmail = async () => {
      const response = await post("/login/recuperarClave", payload);
      console.log(response);
    };
    sendEmail();
  }
  }

  return (
    <div className="flex items-center min-h-screen p-6 bg-gray-100 dark:bg-gray-900">
      <div className="flex-1 h-full max-w-lg mx-auto overflow-hidden bg-white rounded-lg shadow-xl dark:bg-gray-800">
        <main className="flex items-center justify-center p-6 sm:p-12 md:w-2/2">
          <div className="w-full flex items-center justify-center flex-col text-center">
            <h1 className="mb-6 text-3xl font-semibold font-sans text-[#001554] dark:text-gray-200">
              Resetear contraseña
            </h1>

            <Label>
              <p className="text-[#001554] text-base font-sans mt-4">
                Para resetear tu contraseña, te mandaremos un
                <br />
                código al correo electrónico:
              </p>
            </Label>

            <Label className="mt-6 text-base"
            style={{width:'100%'}}
            >
              <span className="font-sans text-[#001554]"></span>
              <Input
                className="mt-1"
                
                placeholder="Ingrese su correo electrónico"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />

            </Label>

              <button 
              onClick={() => 
                handleResetPassword()
              }
              className="bg-[#297DE2] hover:bg-[#1B147A] text-white font-medium font-sans w-72 py-3 mt-10 px-14 rounded">
                Enviar código
              </button>
          </div>
        </main>
      </div>
    </div>
  );
};

export default ConfirmAccount;
