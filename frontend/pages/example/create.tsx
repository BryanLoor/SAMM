import Link from "next/link";
import React from "react";

const CreateAccount = () => {
  return (
    <div className="flex flex-col items-center justify-center h-screen">
      <h1 className=" font-sans text-4xl font-bold text-center mb-16 text-[#001554] font-Poppins">
        ¿Nuevo en S.A.A.M?
      </h1>
      <div className="text-center text-[#001554] text-xl font-Poppins">
        <p className="font-sans">
          No te preocupes, registrarte es muy fácil y rápido.
          <br />
          En cuestión de minutos ya tendrás una cuenta nueva.
        </p>

        <Link href="/example/create-account" passHref={true}>
          <button className="px-32 py-3 font-semibold text-white mt-16 bg-[#297DE2] hover:bg-blue-600 rounded-lg font-sans">
            Empezar
          </button>
        </Link>
      </div>
    </div>
  );
};

export default CreateAccount;
