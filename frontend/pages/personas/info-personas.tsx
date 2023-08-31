import React, { useState, useEffect } from "react";
import Layout from "example/containers/Layout";
import response, { ITableData } from "utils/demo/tableData";
import {
  Chart,
  ArcElement,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
} from "chart.js";
import SectionTitle from "example/components/Typography/SectionTitle";
import { Avatar, Typography } from "@mui/material";
import { Label } from "@roketid/windmill-react-ui";
import Link from "next/link";
import classNames from "classnames";
import { get } from "utils/services/api";

function InfoPersonas() {
  Chart.register(
    ArcElement,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend
  );

  const [page, setPage] = useState(1);
  const [data, setData] = useState<ITableData[]>([]);
  const [isActive, setIsActive] = useState(true);

  const [identificacion, setIdentificacion] = useState("1105496309");
  const [editandoIdentificacion, setEditandoIdentificacion] = useState(false);

  const [telefonoDomicilio, setTelefonoDomicilio] = useState("N/A");
  const [editandoTelefonoDomicilio, setEditandoTelefonoDomicilio] =
    useState(false);

  const [correoDomicilio, setCorreoDomicilio] = useState("N/A");
  const [editandoCorreoDomicilio, setEditandoCorreoDomicilio] = useState(false);

  const [direccionDomicilio, setDireccionDomicilio] = useState(
    "Quito, valle de los chillos, urbanización la colina"
  );
  const [editandoDireccionDomicilio, setEditandoDireccionDomicilio] =
    useState(false);

  const [celularPersonal, setCelularPersonal] = useState("0993189641");
  const [editandoCelularPersonal, setEditandoCelularPersonal] = useState(false);

  const [cargo, setCargo] = useState("Administrador");
  const [editandoCargo, setEditandoCargo] = useState(false);

  // Función para mostrar el modal de editar identificación
  const handleIdentificacionChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setIdentificacion(e.target.value);
  };

  const handleEditarIdentificacion = () => {
    setEditandoIdentificacion(true);
  };

  const handleGuardarIdentificacion = () => {
    setEditandoIdentificacion(false);
  };

  // Función para mostrar el modal de editar teléfono domicilio
  const handleTelefonoDomicilioChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setTelefonoDomicilio(e.target.value);
  };

  const handleEditarTelefonoDomicilio = () => {
    setEditandoTelefonoDomicilio(true);
  };

  const handleGuardarTelefonoDomicilio = () => {
    setEditandoTelefonoDomicilio(false);
  };

  // Función para mostrar el modal de editar correo domicilio
  const handleCorreoDomicilioChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setCorreoDomicilio(e.target.value);
  };

  const handleEditarCorreoDomicilio = () => {
    setEditandoCorreoDomicilio(true);
  };

  const handleGuardarCorreoDomicilio = () => {
    setEditandoCorreoDomicilio(false);
  };

  // Función para mostrar el modal de editar dirección domicilio
  const handleDireccionDomicilioChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setDireccionDomicilio(e.target.value);
  };

  const handleEditarDireccionDomicilio = () => {
    setEditandoDireccionDomicilio(true);
  };

  const handleGuardarDireccionDomicilio = () => {
    setEditandoDireccionDomicilio(false);
  };

  // Función para mostrar el modal de editar celular personal
  const handleCelularPersonalChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setCelularPersonal(e.target.value);
  };

  const handleEditarCelularPersonal = () => {
    setEditandoCelularPersonal(true);
  };

  const handleGuardarCelularPersonal = () => {
    setEditandoCelularPersonal(false);
  };

  // Función para mostrar el modal de editar cargo
  const handleCargoChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setCargo(e.target.value);
  };

  const handleEditarCargo = () => {
    setEditandoCargo(true);
  };

  const handleGuardarCargo = () => {
    setEditandoCargo(false);
  };

  // GAURDAR TODOS LOS CAMBIOS
  const handleGuardarCambios = () => {};

  // API
  interface ITableData {
    FechaCrea: string;
    usuario: string;
    id: number;
    nombre: string;
    apellidos: string;
    identificacion: string;
    celular: string;
    status_actividad: string;
    status_rondas: string;
  }

  useEffect(() => {
    const fetchData = async () => {
      const result = await get("/visitas/getAgentes");
      setData(result);
    };
    fetchData();
  }, []);

  // pagination setup
  const resultsPerPage = 10;
  const totalResults = response.length;

  // pagination change control
  function onPageChange(p: number) {
    setPage(p);
  }

  // Btn ir atrás
  function goBack() {
    setPage(page - 1);
  }

  // Función para activar/desactivar al usuario
  function toggleUser() {
    setIsActive(!isActive);
  }

  return (
    <Layout>
      <Link href="/example/personas">
        <button
          className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-lg py-1 px-4 rounded-md mt-4"
          onClick={goBack}
        >
          Ir atrás
        </button>
      </Link>

      {data.map((row) => (
        <div className="px-4 mb-4 mt-4 bg-white rounded-lg shadow-m">
          <div className="mb-2 mt-2 flex flex-row justify-between">
            <div className="flex">
              <Avatar
                alt="Logo"
                src="/path/to/logo.png"
                sx={{ width: 60, height: 60 }}
              />
              <div className="ml-4 mt-3">
                <Typography variant="h6" className="text-[#001554]">
                  {row.nombre} {row.apellidos}
                </Typography>
              </div>
            </div>

            <div className="mt-3">
              <button
                onClick={toggleUser}
                className={classNames({
                  "bg-[#03C988]": isActive,
                  "bg-gray-500": !isActive,
                  "hover:bg-green-600": isActive,
                  "hover:bg-gray-600": !isActive,
                  "text-white": true,
                  "font-sans": true,
                  "text-sm": true,
                  "py-2": true,
                  "px-4": true,
                  "rounded-md": true,
                  "font-medium": true,
                })}
              >
                {isActive ? "Usuario Activo" : "Usuario Desabilitad"}
              </button>
            </div>
          </div>
          <hr />
          <div className="flex flex-row flex-nowrap justify-between font-sans mt-2 mb-2 mx-14">
            <Typography variant="subtitle2" className="text-[#001554]">
              Nombre de usuario:
              <br />
              <p className="font-normal text-[#0040AE]">{row.usuario}</p>
            </Typography>
            <Typography variant="subtitle2" className="text-[#001554]">
              Fecha de creación:
              <br />
              <p className="font-normal text-[#0040AE]">{row.FechaCrea}</p>
            </Typography>
            <Typography variant="subtitle2" className="text-[#001554]">
              Fecha de modificación:
              <br />
              <p className="font-normal text-[#0040AE]">{"02/02/2023"}</p>
            </Typography>
          </div>
        </div>
      ))}
      <div className="px-4 bg-white rounded-lg shadow-md">
        <div className="flex flex-row justify-between">
          <SectionTitle>
            <p className="text-[#001554] mt-6">Datos personales</p>
          </SectionTitle>
          <button
            className="bg-[#297DE2] hover:bg-[#0040AE] text-white font-sans font-medium text-sm h-8 w-36 rounded-md mt-6"
            onClick={handleGuardarCambios}
          >
            Guardar Cambios
          </button>
        </div>

        <div className="flex flex-col overflow-y-auto md:flex-row">
          <main className="flex items-center justify-center sm:p-4 md:w-1/2">
            <div className="w-80">
              <Label about="identificacion">
                <span className="font-sans text-[#001554] font-medium text-base">
                  Identificación
                </span>
                {editandoIdentificacion ? (
                  <input
                    type="text"
                    className="mt-1 block w-60 text-base rounded-md bg-gray-100 border-transparent focus:border-gray-500 focus:bg-white focus:ring-0"
                    value={identificacion}
                    onChange={handleIdentificacionChange}
                  />
                ) : (
                  <p className="font-sans font-normal text-base text-[#0040AE]">
                    {identificacion}
                  </p>
                )}
              </Label>

              {editandoIdentificacion ? (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleGuardarIdentificacion}
                >
                  Guardar
                </button>
              ) : (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleEditarIdentificacion}
                >
                  Editar
                </button>
              )}

              <Label className="mt-4">
                <span className="font-sans text-[#001554] font-medium text-base ">
                  Teléfono domicilio
                </span>
                {editandoTelefonoDomicilio ? (
                  <input
                    type="text"
                    className="mt-1 block w-full rounded-md bg-gray-100 border-transparent focus:border-gray-500 focus:bg-white focus:ring-0"
                    value={telefonoDomicilio}
                    onChange={handleTelefonoDomicilioChange}
                  />
                ) : (
                  <p className="font-sans font-normal text-base text-[#0040AE]">
                    {telefonoDomicilio}
                  </p>
                )}
              </Label>

              {editandoTelefonoDomicilio ? (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleGuardarTelefonoDomicilio}
                >
                  Guardar
                </button>
              ) : (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleEditarTelefonoDomicilio}
                >
                  Editar
                </button>
              )}

              <Label className="mt-4 ">
                <span className="font-sans text-[#001554] font-medium text-base">
                  Correo domicilio
                </span>
                {editandoCorreoDomicilio ? (
                  <input
                    type="text"
                    className="mt-1 block w-full rounded-md bg-gray-100 border-transparent focus:border-gray-500 focus:bg-white focus:ring-0"
                    value={correoDomicilio}
                    onChange={handleCorreoDomicilioChange}
                  />
                ) : (
                  <p className="font-sans font-normal text-base text-[#0040AE]">
                    {correoDomicilio}
                  </p>
                )}
              </Label>

              {editandoCorreoDomicilio ? (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleGuardarCorreoDomicilio}
                >
                  Guardar
                </button>
              ) : (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleEditarCorreoDomicilio}
                >
                  Editar
                </button>
              )}
            </div>
          </main>
          <main className="flex items-center justify-center sm:p-4 md:w-2/2">
            <div className="w-80 font-sans">
              <Label className="">
                <span className="font-sans text-[#001554] font-medium text-base">
                  Dirección domicilio
                </span>
                {editandoDireccionDomicilio ? (
                  <input
                    type="text"
                    className="mt-1 block w-full rounded-md bg-gray-100 border-transparent focus:border-gray-500 focus:bg-white focus:ring-0"
                    value={direccionDomicilio}
                    onChange={handleDireccionDomicilioChange}
                  />
                ) : (
                  <p className="font-sans font-normal text-base text-[#0040AE]">
                    {direccionDomicilio}
                  </p>
                )}
              </Label>

              {editandoDireccionDomicilio ? (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleGuardarDireccionDomicilio}
                >
                  Guardar
                </button>
              ) : (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleEditarDireccionDomicilio}
                >
                  Editar
                </button>
              )}

              <Label className="mt-4">
                <span className="font-sans text-[#001554] font-medium text-base">
                  Celular personal
                </span>
                {editandoCelularPersonal ? (
                  <input
                    type="text"
                    className="mt-1 block w-full rounded-md bg-gray-100 border-transparent focus:border-gray-500 focus:bg-white focus:ring-0"
                    value={celularPersonal}
                    onChange={handleCelularPersonalChange}
                  />
                ) : (
                  <p className="font-sans font-normal text-base text-[#0040AE]">
                    {celularPersonal}
                  </p>
                )}
              </Label>

              {editandoCelularPersonal ? (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleGuardarCelularPersonal}
                >
                  Guardar
                </button>
              ) : (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleEditarCelularPersonal}
                >
                  Editar
                </button>
              )}

              <Label className="mt-4">
                <span className="font-sans text-[#001554] font-medium text-base">
                  Cargo
                </span>
                {editandoCargo ? (
                  <input
                    type="text"
                    className="mt-1 block w-full rounded-md bg-gray-100 border-transparent focus:border-gray-500 focus:bg-white focus:ring-0"
                    value={cargo}
                    onChange={handleCargoChange}
                  />
                ) : (
                  <p className="font-sans font-normal text-base text-[#0040AE]">
                    {cargo}
                  </p>
                )}
              </Label>

              {editandoCargo ? (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleGuardarCargo}
                >
                  Guardar
                </button>
              ) : (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleEditarCargo}
                >
                  Editar
                </button>
              )}
            </div>
          </main>
        </div>
      </div>
    </Layout>
  );
}

export default InfoPersonas;
