import React, { useEffect,useState } from "react";
import { Input, Label, TableHeader } from "@roketid/windmill-react-ui";
import PageTitle from "example/components/Typography/PageTitle";
import SectionTitle from "example/components/Typography/SectionTitle";
import Layout from "example/containers/Layout";
import {Table,TableBody,TableCell,TableContainer,TableRow,} from "@mui/material";
import { get } from "utils/services/api";
import ModalUsuario from "./modal-crear-usuario";
import Link from "next/link";

function Usuarios() {
  const [data, setData] = React.useState<ITableData[]>([]);
  interface ITableData {
    id: number;
    codigo: string;
    nombres: string;
    apellidos: string;
    estado: string;
    usuariocrea: string;
    fechacrea: string;
    usuariomodifica: string;
    fechamodifica: string;
  }

  useEffect(() => {
    const fetchData = async () => {
      const result = await get("/visitas/usuarios");
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
                <TableCell>Id</TableCell>
                <TableCell>Codigo</TableCell>
                <TableCell>Nombres</TableCell>
                <TableCell>Apellidos</TableCell>
                <TableCell>Estado</TableCell>
                <TableCell>UsuarioCrea</TableCell>
                <TableCell>FechaCrea</TableCell>
                <TableCell>UsuarioModifica</TableCell>
                <TableCell>FechaModifica</TableCell>
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
                    <span className="text-sm">{row.codigo}</span>
                  </TableCell>
                  <TableCell>
                    <Link href="/example/info-usuario">
                      <span className="text-sm text-blue-800 hover:text-blue-900 underline">
                        {row.nombres}
                      </span>
                    </Link>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{row.apellidos}</span>
                  </TableCell>
                  <TableCell className="text-center">
                    <span className="text-sm">
                      {row.estado === "A" ? "Activo" : "Inactivo"}
                    </span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm"> {row.usuariocrea} </span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm"> {row.fechacrea} </span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm"> {row.usuariomodifica} </span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm"> {row.fechamodifica} </span>
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
