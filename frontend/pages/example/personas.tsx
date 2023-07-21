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
import Link from "next/link";
import ModalPersonas from "./modal-crear-persona";

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
            <p className="font-sans text-[#001554]">Registro Personas</p>
          </PageTitle>
        </div>
        <div className="mt-4">
          <ModalPersonas />
        </div>
      </div>

      <div className="px-4 py-3 mb-8 bg-white rounded-lg shadow-md dark:bg-gray-800">
        <SectionTitle>
          <p className="text-[#001554] mt-2">Personas</p>
        </SectionTitle>
        <TableContainer className="mb-8">
          <Table>
            <TableHeader>
              <tr className=" text-[#0040AE]">
                <TableCell></TableCell>
                <TableCell>#</TableCell>
                <TableCell>Identificación</TableCell>
                <TableCell>teléfono domicilio</TableCell>
                <TableCell>Correo domicilio</TableCell>
                <TableCell>Dirección domicilio</TableCell>
                <TableCell>Celular personal</TableCell>
                <TableCell>Cargo</TableCell>
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
                    <span className="text-sm">{""}</span>
                  </TableCell>
                  <TableCell>
                    <Link href="/example/info-personas">
                      <span className="text-sm text-blue-800 hover:text-blue-900 underline">
                        {"1105496309"}
                      </span>
                    </Link>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{"N/A"}</span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{"N/A"}</span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">
                      {"Quito, valle de los chillos, urbanización la colina"}
                    </span>
                  </TableCell>
                  <TableCell className="text-center">
                    <span className="text-sm">{"0993189641"}</span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{"adminitrador"}</span>
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
