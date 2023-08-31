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

function InfoUsuarios() {
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
  const [userData, setUserData] = useState([]); // [
  const [isActive, setIsActive] = useState(true);
  const [nombresCompletos, setNombresCompletos] = useState("Fiona");
  const [apellidosCompletos, setApellidosCompletos] = useState("Guerra");
  const [identificacion, setIdentificacion] = useState("1105496309");
  const [celular, setCelular] = useState("0993189641");
  const [correoElectronico, setCorreoElectronico] = useState("N/A");
  const [roles, setRoles] = useState("admininistardor");
  const [cargos, setCargos] = useState("administrador");
  const [ubicacion, setUbicacion] = useState("N/A");

  // editar campos
  const [editandoNombres, setEditandoNombres] = useState(false);
  const [editandoApellidos, setEditandoApellidos] = useState(false);
  const [editandoIdentificacion, setEditandoIdentificacion] = useState(false);
  const [editandoCelular, setEditandoCelular] = useState(false);
  const [editandoCorreoElectronico, setEditandoCorreoElectronico] =
    useState(false);
  const [editandoRoles, setEditandoRoles] = useState(false);
  const [editandoCargos, setEditandoCargos] = useState(false);
  const [editandoUbicacion, setEditandoUbicacion] = useState(false);

  const handleNombresCompletosChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setNombresCompletos(e.target.value);
  };

  const handleApellidosCompletosChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setApellidosCompletos(e.target.value);
  };

  const handleIdentificacionChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setIdentificacion(e.target.value);
  };

  const handleCelularChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setCelular(e.target.value);
  };

  const handleCorreoElectronicoChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setCorreoElectronico(e.target.value);
  };

  const handleRolesChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setRoles(e.target.value);
  };

  const handleCargosChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setCargos(e.target.value);
  };

  const handleUbicacionChange = (e: {
    target: { value: React.SetStateAction<string> };
  }) => {
    setUbicacion(e.target.value);
  };

  const handleEditarNombres = () => {
    setEditandoNombres(true);
  };

  const handleEditarApellidos = () => {
    setEditandoApellidos(true);
  };

  const handleEditarIdentificacion = () => {
    setEditandoIdentificacion(true);
  };

  const handleEditarCelular = () => {
    setEditandoCelular(true);
  };

  const handleEditarCorreoElectronico = () => {
    setEditandoCorreoElectronico(true);
  };

  const handleEditarRoles = () => {
    setEditandoRoles(true);
  };

  const handleEditarCargos = () => {
    setEditandoCargos(true);
  };

  const handleEditarUbicacion = () => {
    setEditandoUbicacion(true);
  };

  // GUARDAR TODOS LOS CAMBIOS
  const handleGuardarCambios = () => {
    setEditandoNombres(false);
    setEditandoApellidos(false);
    setEditandoIdentificacion(false);
    setEditandoCelular(false);
    setEditandoCorreoElectronico(false);
    setEditandoRoles(false);
    setEditandoCargos(false);
    setEditandoUbicacion(false);
  };

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

    // const fetchUserData = async () => {
    //   const result = await get("/visitas/usuarios/1");
    //   setUserData(result);
    // };

    // fetchUserData();
  }, []);

  return (
    <Layout>
      <Link href="/example/usuarios">
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
                {isActive ? "Usuario Activo" : "Usuario Desabilitado"}
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
      <div className="px-4 bg-white rounded-lg shadow-md mb-6">
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
              <Label about="nombres">
                <span className="font-sans text-[#001554] font-medium text-base">
                  Nombres completos
                </span>
                {editandoNombres ? (
                  <input
                    type="text"
                    className="mt-1 block w-60 text-base rounded-md bg-gray-100 border-transparent focus:border-gray-500 focus:bg-white focus:ring-0"
                    value={nombresCompletos}
                    onChange={handleNombresCompletosChange}
                  />
                ) : (
                  <p className="font-sans font-normal text-base text-[#0040AE]">
                    {nombresCompletos}
                  </p>
                )}
              </Label>
              {editandoNombres ? (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleGuardarCambios}
                >
                  Guardar
                </button>
              ) : (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleEditarNombres}
                >
                  Editar
                </button>
              )}
              <Label about="apellidos" className="mt-4">
                <span className="font-sans text-[#001554] font-medium text-base">
                  Apellidos completos
                </span>
                {editandoApellidos ? (
                  <input
                    type="text"
                    className="mt-1 text-base block w-60 rounded-md bg-gray-100 border-transparent focus:border-gray-500 focus:bg-white focus:ring-0"
                    value={apellidosCompletos}
                    onChange={handleApellidosCompletosChange}
                  />
                ) : (
                  <p className="font-sans font-normal text-base text-[#0040AE]">
                    {apellidosCompletos}
                  </p>
                )}
              </Label>
              {editandoApellidos ? (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleGuardarCambios}
                >
                  Guardar
                </button>
              ) : (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleEditarApellidos}
                >
                  Editar
                </button>
              )}

              <Label about="identificacion" className="mt-4">
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
                  onClick={handleGuardarCambios}
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

              <Label about="celular" className="mt-4">
                <span className="font-sans text-[#001554] font-medium text-base">
                  Celular
                </span>
                {editandoCelular ? (
                  <input
                    type="text"
                    className="mt-1 text-base block w-full rounded-md bg-gray-100 border-transparent focus:border-gray-500 focus:bg-white focus:ring-0"
                    value={celular}
                    onChange={handleCelularChange}
                  />
                ) : (
                  <p className="font-sans text-base font-normal text-[#0040AE]">
                    {celular}
                  </p>
                )}
              </Label>
              {editandoCelular ? (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleGuardarCambios}
                >
                  Guardar
                </button>
              ) : (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleEditarCelular}
                >
                  Editar
                </button>
              )}
            </div>
          </main>
          <main className="flex items-center justify-center sm:p-4 md:w-2/2">
            <div className="w-80 font-sans">
              <Label about="correo">
                <span className="font-sans text-[#001554] font-medium text-base">
                  Correo electrónico
                </span>
                {editandoCorreoElectronico ? (
                  <input
                    type="text"
                    className="mt-1 block w-60 text-base rounded-md bg-gray-100 border-transparent focus:border-gray-500 focus:bg-white focus:ring-0"
                    value={correoElectronico}
                    onChange={handleCorreoElectronicoChange}
                  />
                ) : (
                  <p className="font-sans font-normal text-base text-[#0040AE]">
                    {correoElectronico}
                  </p>
                )}
              </Label>
              {editandoCorreoElectronico ? (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleGuardarCambios}
                >
                  Guardar
                </button>
              ) : (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleEditarCorreoElectronico}
                >
                  Editar
                </button>
              )}
              <Label about="roles" className="mt-4">
                <span className="font-sans text-[#001554] font-medium text-base">
                  Roles
                </span>
                {editandoRoles ? (
                  <input
                    type="text"
                    className="mt-1 block w-60 text-base rounded-md bg-gray-100 border-transparent focus:border-gray-500 focus:bg-white focus:ring-0"
                    value={roles}
                    onChange={handleRolesChange}
                  />
                ) : (
                  <p className="font-sans font-normal text-base text-[#0040AE]">
                    {roles}
                  </p>
                )}
              </Label>
              {editandoRoles ? (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleGuardarCambios}
                >
                  Guardar
                </button>
              ) : (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleEditarRoles}
                >
                  Editar
                </button>
              )}
              <Label about="cargos" className="mt-4">
                <span className="font-sans text-[#001554] font-medium text-base">
                  Cargos
                </span>
                {editandoCargos ? (
                  <input
                    type="text"
                    className="mt-1 block w-60 text-base rounded-md bg-gray-100 border-transparent focus:border-gray-500 focus:bg-white focus:ring-0"
                    value={cargos}
                    onChange={handleCargosChange}
                  />
                ) : (
                  <p className="font-sans font-normal text-base text-[#0040AE]">
                    {cargos}
                  </p>
                )}
              </Label>
              {editandoCargos ? (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleGuardarCambios}
                >
                  Guardar
                </button>
              ) : (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleEditarCargos}
                >
                  Editar
                </button>
              )}

              <Label about="ubicacion" className="mt-4">
                <span className="font-sans text-[#001554] font-medium text-base">
                  Ubicación o lugar de trabajo
                </span>
                {editandoUbicacion ? (
                  <input
                    type="text"
                    className="mt-1 block w-60 text-base rounded-md bg-gray-100 border-transparent focus:border-gray-500 focus:bg-white focus:ring-0"
                    value={ubicacion}
                    onChange={handleUbicacionChange}
                  />
                ) : (
                  <p className="font-sans font-normal text-base text-[#0040AE] w-96">
                    {ubicacion}
                  </p>
                )}
              </Label>
              {editandoUbicacion ? (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleGuardarCambios}
                >
                  Guardar
                </button>
              ) : (
                <button
                  className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans text-sm py-1 px-2 rounded-md mt-2"
                  onClick={handleEditarUbicacion}
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

export default InfoUsuarios;
