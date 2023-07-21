import { Input, Label } from "@roketid/windmill-react-ui";
import Link from "next/link";
import React from "react";

const ConfirmAccount = () => {
  return (
    <div className="flex items-center min-h-screen p-6 bg-gray-100 dark:bg-gray-900">
      <div className="flex-1 h-full max-w-lg mx-auto overflow-hidden bg-white rounded-lg shadow-xl dark:bg-gray-800">
        <main className="flex items-center justify-center p-6 sm:p-12 md:w-2/2">
          <div className="w-full flex items-center justify-center flex-col text-center">
            <h1 className="mb-6 text-3xl font-semibold font-sans text-[#001554] dark:text-gray-200">
              Recuperar correo electrónico
            </h1>

            <Label>
              <p className="text-[#001554] text-base font-sans mt-4">
                ¡Listo!, tu correo electrónico fue recuperado
                <br />
                con éxito. El mismo es el siguiente:
              </p>
            </Label>

            <Label className="mt-6 text-base">
              <span className="text-[#297DE2] font-sans font-medium">
                geomena@digotec.ec
              </span>
            </Label>

            <Link href="/example/login" passHref={true}>
              <button className="bg-[#297DE2] hover:bg-[#1B147A] text-white font-medium font-sans w-72 py-3 mt-8 px-14 rounded">
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
