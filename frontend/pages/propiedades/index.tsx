import React, { useState, useEffect } from "react";
import PageTitle from "example/components/Typography/PageTitle";
import Layout from "components/layout"
import { ITableData } from "utils/demo/tableData";

import { Input, Label, TableHeader } from "@roketid/windmill-react-ui";

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
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableRow,
} from "@mui/material";
import ModalPropiedad from "./modal-crear-propiedad";
import { get } from "utils/services/api";

function Dashboard() {
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
  const [response, setResponse] = useState<any>([])

  // pagination setup
  const resultsPerPage = 10;
  //const totalResults = response.length;

  // pagination change control
  function onPageChange(p: number) {
    setPage(p);
  }

  // on page change, load new sliced data
  // here you would make another server request for new data
  async function getDataAll() {
    const results = await get("/visitas/getUrbanizaciones");
    console.log(JSON.stringify(results))
    setResponse(results);
  }
  useEffect(() => {
    getDataAll();
    setData(response.slice((page - 1) * resultsPerPage, page * resultsPerPage));
  }, [page]);

  return (
    <Layout>
      <div className="flex flex-row justify-between mb-4">
        <div>
          <PageTitle>
            <p className="font-sans text-[#001554]">Registro Propiedades</p>
          </PageTitle>
        </div>
        <div className="mt-4">
          <ModalPropiedad />
        </div>
      </div>

      <div className="px-4 py-3 mb-8 bg-white rounded-lg shadow-md dark:bg-gray-800">
        <SectionTitle>
          <p className="text-[#001554] mt-2">Propiedades</p>
        </SectionTitle>

        <TableContainer className="mb-8">
          <Table>
            <TableHeader>
              <tr className=" text-[#0040AE]">
                <TableCell></TableCell>
                <TableCell>#</TableCell>
                <TableCell>Nombre</TableCell>
                <TableCell>Ubicación</TableCell>
                <TableCell>Número propiedades</TableCell>
                <TableCell>Agentes activos</TableCell>
                <TableCell>Status rondas</TableCell>
              </tr>
            </TableHeader>
            <TableBody>

              {response.map((item: any) => (
                <TableRow className="text-[#001554]" key={item.id}>
                  <TableCell>
                    <div className="flex items-center text-sm">
                      <Label check>
                        <Input type="checkbox" />
                      </Label>
                    </div>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{item.id}</span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{item.nombre}</span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{item.direccion}</span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{item.cantidad_propiedades?item.cantidad_propiedades:0
                    } propiedades
                    </span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{item.cantidad_Agentes} agentes activos
                    </span>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm">{item.cantidad_Rondas} rondas completadas

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

export default Dashboard;
