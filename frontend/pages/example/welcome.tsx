import React, { useContext, useEffect } from "react";
import { useRouter } from "next/router";
import { Label, WindmillContext } from "@roketid/windmill-react-ui";
import Link from "next/link";
import Image from "next/image";

const Carga: React.FC = () => {
  const router = useRouter();
  const { mode } = useContext(WindmillContext);
  const imgSource =
    mode === "dark" ? "/assets/img/SAMM.png" : "/assets/img/SAMM.png";

  useEffect(() => {
    const timer = setTimeout(() => {
      router.push("/example");
    }, 3000);

    return () => {
      clearTimeout(timer);
    };
  }, [router]);

  return (
    <div className="flex items-center min-h-screen p-6 bg-[#0040AE] dark:bg-gray-900">
      <div className="flex-1 h-full max-w-sm mx-auto overflow-hidden bg-[#0040AE] rounded-lg dark:bg-gray-800">
        <main className="flex items-center justify-center p-6 sm:p-12 md:w-2/2">
          <div className="w-full flex items-center justify-center flex-col text-center">
            <div className="relative h-32 md:h-auto md:w-1/2 grid justify-center items-center">
              <Image
                aria-hidden="true"
                src={imgSource}
                alt="Office"
                width={350}
                height={350}
              />
            </div>
            <h1 className="mb-6 text-xl font-sans text-white dark:text-gray-200">
              Espera un momento...
            </h1>
          </div>
        </main>
      </div>
    </div>
  );
};
export default Carga;
