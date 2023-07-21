import { Input, Label } from "@roketid/windmill-react-ui";
import Link from "next/link";
import React from "react";

const ConfirmAccount = () => {
  return (
    <div className="flex items-center min-h-screen p-6 bg-gray-100 dark:bg-gray-900">
      <div className="flex-1 h-full max-w-sm mx-auto overflow-hidden bg-white rounded-lg shadow-xl dark:bg-gray-800">
        <main className="flex items-center justify-center p-6 sm:p-12 md:w-2/2">
          <div className="w-full flex items-center justify-center flex-col text-center">
            <h1 className="mb-6 text-xl font-semibold font-sans text-[#001554] dark:text-gray-200">
              ¡Listo! Revisa tu correo.
            </h1>

            <Label>
              <p className="text-[#001554] text-base font-sans">
                Para completar tu registro se requiere una verificación de
                correo electrónico.
                <br />
                Por favor, revisa tu buzón de correo y sigue las instrucciones
                enviadas.
              </p>
            </Label>

            <Label className="mt-6 text-base">
              <span className="text-[#001554] font-sans">
                El correo fue enviado a:
              </span>
            </Label>

            {/* <p className="mb-4 flex justify-end">
              <Link href="/example/forgot-password" legacyBehavior>
                <a className="text-sm font-sans text-[#1B147A] dark:text-purple-400 hover:underline">
                  ¿Olvidaste tu correo y/o contraseña?
                </a>
              </Link>
            </p> */}

            <Link href="/example/login" passHref={true}>
              <button className="bg-[#1B147A] hover:bg-[#1B147A] text-white font-semibold font-sans w-full py-2 px-14 rounded mt-6">
                OK
              </button>
            </Link>
          </div>
        </main>
      </div>
    </div>
  );
};

export default ConfirmAccount;
