import React, { useEffect } from "react";
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

function Usuarios() {
  const [data, setData] = React.useState<ITableData[]>([]);
  interface ITableData {
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

  return (
    <Layout>
      <div className="flex flex-row justify-between mb-4">
        <div>
          <PageTitle>
            <p className="font-sans text-[#001554]">Registro Usuarios</p>
          </PageTitle>
        </div>
        <div className="mt-4">
          <ModalUsuario />
        </div>
      </div>

      <div className="px-4 py-3 mb-8 bg-white rounded-lg shadow-md dark:bg-gray-800">
        <SectionTitle>
          <p className="text-[#001554] mt-2">Usuarios</p>
        </SectionTitle>
        <TableContainer className="mb-8">
          <Table>
            <TableHeader>
              <tr className=" text-[#0040AE]">
                <TableCell></TableCell>
                <TableCell>#</TableCell>
                <TableCell>Nombres</TableCell>
                <TableCell>Apellidos</TableCell>
                <TableCell>Identificación</TableCell>
                <TableCell>Celular</TableCell>
                <TableCell>Status actividad</TableCell>
                <TableCell>Status rondas</TableCell>
              </tr>
            </TableHeader>
            <TableBody>
              {data.map((row) => (
                <TableRow className="text-[#001554]" key={row.id}>
                  <TableCell>
                    <div className="flex items-center text-sm">
                      <Label check>
                        <Input type="checkbox" />
                      </Label>
                    </div>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{row.id}</span>
                  </TableCell>
                  <TableCell>
                    <Link href="/example/info-usuario">
                      <span className="text-sm text-blue-800 hover:text-blue-900 underline">
                        {row.nombre}
                      </span>
                    </Link>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{row.apellidos}</span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{row.identificacion}</span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">
                      {row.celular ? row.celular : "No tiene"}
                    </span>
                  </TableCell>
                  <TableCell className="text-center">
                    <span className="text-sm">
                      {row.status_actividad === "A" ? "Activo" : "Inactivo"}
                    </span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">
                      {row.status_rondas} rondas completadas
                    </span>
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

export default Usuarios;
