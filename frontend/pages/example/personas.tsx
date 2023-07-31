import React, { useEffect } from "react";
import { Input, Label, TableHeader } from "@roketid/windmill-react-ui";
import PageTitle from "example/components/Typography/PageTitle";
import SectionTitle from "example/components/Typography/SectionTitle";
import Layout from "example/containers/Layout";
import {
  Box,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableRow,
} from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import { get } from "utils/services/api";
import Link from "next/link";
import ModalPersonas from "./modal-crear-persona";

function Personas() {
  const [data, setData] = React.useState<ITableData[]>([]);
  interface ITableData {
    id: number;
    tipoIdentificacion: string;
    identificacion: string;
    nombres: string;
    apellidos: string;
    correoPersonal: string;
    dirDomicilio: string;
    celPersonal: string;
    status_actividad: string;
    status_rondas: string;
  }

  useEffect(() => {
    const fetchData = async () => {
      const result = await get("/visitas/personas");
      setData(result);
    };
    fetchData();
  }, []);

  const columns = [
    {
      field: "TipoIde",
      headerName: "Tipo identificación",
      width: 150,
    },
    {
      field: "Identificacion",
      headerName: "Identificación",
      width: 150,
    },
    {
      field: "Nombres",
      headerName: "Nombres",
      width: 150,
    },
    {
      field: "Apellidos",
      headerName: "Apellidos",
      width: 150,
    },
    {
      field: "Correo_Personal",
      headerName: "Correo Personal",
      width: 150,
    },
    {
      field: "Dir_Domicilio",
      headerName: "Dirección Domicilio",
      width: 150,
    },
    {
      field: "Cel_Personal",
      headerName: "Celular Personal",
      width: 150,
    },
    {
      field: "Estado",
      headerName: "Estado",
      width: 150,
      renderCell: (row) => {
        return row.value === "A" ? (
          <p style={{ color: "green" }}>Activo</p>
        ) : (
          <p style={{ color: "red" }}>Inactivo</p>
        );
      },
    },
  ];
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
        <Box sx={{ height: 400, width: "100%" }}>
          <DataGrid
            getRowId={(row) => row.Id}
            rows={data}
            columns={columns}
            initialState={{
              pagination: {
                paginationModel: {
                  pageSize: 5,
                },
              },
            }}
            pageSizeOptions={[5]}
          />
        </Box>
      </div>
    </Layout>
  );
}

export default Personas;
