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
              ¿Olvidaste tu correo y/o contraseña?
            </h1>

            <Label>
              <p className="text-[#001554] text-base font-sans mt-4">
                No te preocupes, nosotros te ayudamos.
                <br />
                ¿Qué deseas recuperar?
              </p>
            </Label>

            <Link href="/example/correo/paso-2" passHref={true}>
              <button className="bg-[#297DE2] hover:bg-[#1B147A] text-white font-medium font-sans w-72 py-3 mt-10 px-14 rounded">
                Recuperar correo
              </button>
            </Link>
            <Link href="/example/password/paso-2" passHref={true}>
              <button className="bg-[#297DE2] hover:bg-[#1B147A] text-white font-medium font-sans w-72 py-3 mt-4 px-14 rounded">
                Resetear contraseña
              </button>
            </Link>
          </div>
        </main>
      </div>
    </div>
  );
};

export default ConfirmAccount;
