import React, { useEffect,useState } from "react";
import { Input, Label, TableHeader } from "@roketid/windmill-react-ui";
import PageTitle from "example/components/Typography/PageTitle";
import SectionTitle from "example/components/Typography/SectionTitle";
import Layout from "components/layout"
import {Box,} from "@mui/material";
import { DataGrid, GridColDef } from "@mui/x-data-grid";
import { get } from "utils/services/api";
import Link from "next/link";
import ModalPersonas from "./modal-crear-persona";
import { TRUE } from "sass";

function Personas() {
  const [data, setData] = useState<ITableData[]>([]);
  const [isReloading, setIsReloading] = useState(false);

  interface ITableData {
    id: number;
    tipoIdentificacion: string;
    identificacion: string;
    nombres: string;
    apellidos: string;
    estadoCivil: string;
    Sexo: string;
    correoPersonal: string;
    dirDomicilio: string;
    celPersonal: string;
    
  }

  useEffect(() => {
    const fetchData = async () => {
      const result = await get("/visitas/personas");
      setData(result);
    };
    fetchData();
  }, []);

  const columns: GridColDef[] = [
    {
      field: "TipoIde",
      headerName: "Tipo identificación",
      width: 150,
    },
    {
      field: "Identificacion",
      headerName: "Identificación",
      width: 150,
      editable: true,
    },
    {
      field: "Nombres",
      headerName: "Nombres",
      width: 150,
      editable: true,
    },
  
    {
      field: "Apellidos",
      headerName: "Apellidos",
      width: 150,
      editable: true,
    },
    {
      field: "EstadoCivil",
      headerName: "EstadoCivil",
      width: 150,
      editable: true,
    },
    {
      field: "Correo_Personal",
      headerName: "Correo Personal",
      width: 150,
      editable: true,
    },
    {
      field: "Sexo",
      headerName: "Sexo",
      width: 150,
      renderCell: (params) => {
        const value = params.value as string;
        return value === "M" ? (
          <p>Masculino</p>
        ) : (
          <p>Femenino</p>
        );
      },
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
      renderCell: (params) => {
        const value = params.value as string;
        return value === "A" ? (
          <p style={{ color: "green" }}>Activo</p>
        ) : (
          <p style={{ color: "red" }}>Inactivo</p>
        );
      },
    },
  ];

  const handleReload = () => {
    setIsReloading(true);
    setTimeout(() => {
      setIsReloading(false);
    }, 2000);
    // Realiza la acción de recargar la tabla
  };


  return (
    <Layout>
      <div className="flex flex-row justify-between mb-4">
        <div>
          {/* <PageTitle>
            <p className="font-sans text-[#001554]">Registro Personas</p>
          </PageTitle> */}
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
          Hola
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
