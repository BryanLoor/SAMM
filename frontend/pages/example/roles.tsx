import React, { ReactNode, useEffect, useState } from "react";
import { Input, Label, TableHeader } from "@roketid/windmill-react-ui";
import PageTitle from "example/components/Typography/PageTitle";
import SectionTitle from "example/components/Typography/SectionTitle";
import Layout from "example/containers/Layout";
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableRow,
} from "@mui/material";
import { get } from "utils/services/api";
import ModalUsuario from "./modal-crear-usuario";
import Link from "next/link";
import ModalRol from "./modal-crear-rol";
import ModalAssignRol from "components/ModalAssignRol";
import ModalUpadateRol from "components/ModalUpdateRol";

function Roles() {
  const [data, setData] = React.useState<ITableData[]>([]);
  interface ITableData {
    Descripcion: string;
    FechaModifica: Date;
    UsuarioCrea: string;
    FechaCrea: Date;
    Estado: string;
    Codigo: string;
    Id: number;
    nombre: string;
    apellidos: string;
    identificacion: string;
    celular: string;
    status_actividad: string;
    status_rondas: string;
  }

  useEffect(() => {
    const getRoles = async () => {
      const result = await get("/visitas/roles");
      console.log(result);
      setData(result["roles"]);
    };
    getRoles();
  }, []);

  const handleRowClick = (row: React.SetStateAction<{}>) => {
    setCurrentRowSelected(row);
    setOpenModalUpadateRol(true);
  };

  const [openModalUpadateRol, setOpenModalUpadateRol] = useState(false);
  const [currentRowSelected, setCurrentRowSelected] = useState({});
  return (
    <Layout>
      <div className="flex flex-row justify-between mb-4">
        <div>
          <PageTitle>
            <p className="font-sans text-[#001554]">Registro Roles</p>
          </PageTitle>
        </div>
        <div style={{ display: "flex" }}>
          <div className="mt-4">
            <ModalAssignRol />
          </div>
          <div className="mt-4 ml-10">
            <ModalRol />
          </div>
        </div>
      </div>

      {/* MODAL TO UPDATE EACH ROL WITH SPECIFC INFO */}
      <ModalUpadateRol
        openModalUpadateRol={openModalUpadateRol}
        setOpenModalUpadateRol={setOpenModalUpadateRol}
        row={currentRowSelected}
        updateAllInfoRoles={setData}
      />

      <div className="px-4 py-3 mb-8 bg-white rounded-lg shadow-md dark:bg-gray-800">
        <SectionTitle>
          <p className="text-[#001554] mt-2">Roles</p>
        </SectionTitle>
        <TableContainer className="mb-8">
          <Table>
            <TableHeader>
              <tr className=" text-[#0040AE]">
                <TableCell></TableCell>
                <TableCell>#</TableCell>
                <TableCell>Codigo</TableCell>
                <TableCell>Estado</TableCell>
                <TableCell className="text-center">Fecha Creacion</TableCell>
                <TableCell>Usuario</TableCell>
                <TableCell className="text-center">
                  Fecha modificacion
                </TableCell>
                <TableCell>ultimo login</TableCell>
                <TableCell>Descripcion</TableCell>
              </tr>
            </TableHeader>
            <TableBody>
              {data.map((row) => (
                <TableRow
                  className="text-[#001554]"
                  key={row.Id}
                  onClick={() => handleRowClick(row)}
                  sx={{
                    cursor: "pointer",
                    "&:hover": {
                      // Estilo cuando se hace hover en la fila
                      backgroundColor: "lightgray",
                    },
                  }}
                >
                  <TableCell>
                    <div className="flex items-center text-sm">
                      <Label check>
                        <Input type="checkbox" />
                      </Label>
                    </div>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{row.Id}</span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm hover:text-blue-800">
                      {row.Codigo}
                    </span>
                  </TableCell>
                  <TableCell>
                    <span
                      className="text-sm"
                      style={
                        row.Estado == "A"
                          ? { color: "green" }
                          : { color: "red" }
                      }
                    >
                      {row.Estado == "A" ? "Activo" : "Inactivo"}
                    </span>
                  </TableCell>
                  <TableCell className="text-center">
                    <span className="text-sm">{row.FechaCrea?.toString()}</span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{row.UsuarioCrea}</span>
                  </TableCell>
                  <TableCell className="text-center">
                    <span className="text-sm">{row.FechaModifica?.toString()}</span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{row.Descripcion}</span>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </TableContainer>
      </div>
    </Layout>
  );
}

export default Roles;
