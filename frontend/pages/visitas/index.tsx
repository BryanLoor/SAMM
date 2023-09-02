import { useEffect, useState } from "react";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import { useDemoData } from "@mui/x-data-grid-generator";
import Layout from "components/layout";
import ModalVisita from "./modal-crear-visita";
import { get } from "utils/services/api";
import { Button } from "@mui/material";

import ModalEditarVisita from "./modalEditarVisita";

const VISIBLE_FIELDS = ["name", "rating", "country", "dateCreated", "isAdmin"];
const detectVistaStatus = (status) => {
  let message = "";
  switch (status) {
    case "A":
      message = "activa";

      break;
    case "C":
      message = "completada";

      break;
    case "I":
      message = "inválida";
      break;
    default:
      break;
  }

  return message;
};

const formatearFecha = (date) => {
  const fechaOriginal = date;

  // Crear un objeto Date a partir de la fecha original
  const fecha = new Date(fechaOriginal);

  // Formatear la fecha en un formato personalizado (por ejemplo, "31 de agosto de 2023, 20:41")
  const options = {
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "numeric",
    minute: "numeric",
  };
  const fechaFormateada = fecha.toLocaleDateString("es-ES", options);
  return fechaFormateada;
};

const VisitasPage = () => {
  const columns = [
    { field: "Id", headerName: "ID", width: 90 },
    {
      field: "",
      headerName: "Edición",
      width: 90,
      renderCell: (params) => {
        return (
          <ModalEditarVisita
            visita={params.row}
            detectVistaStatus={detectVistaStatus}
            getAllBitacoras={getAllBitacoras}
          />
        );
      },
    },
    {
      field: "Estado",
      headerName: "Status visita",
      width: 90,
      renderCell: (params) => <div>{detectVistaStatus(params.row.Estado)}</div>,
    },

    {
      field: "NombresVisitante",
      headerName: "Status visita",
      width: 150,
    },
    {
      field: "ApellidosVisitante",
      headerName: "Apellidos Visitante",
      width: 150,
    },
    {
      field: "Codigo",
      headerName: "Identificacion Visitante",
      width: 150,
    },
    {
      field: "NombresAnfitrion",
      headerName: "Nombres Anfitrion",
      width: 150,
    },
    {
      field: "ApellidosAnfitrion",
      headerName: "Apellidos Anfitrion",
      width: 150,
    },
    {
      field: "Antecedentes",
      headerName: "Antecedented Penales",
      width: 150,
      renderCell: (params) => (
        <div>{params.row.Antecedentes ? "Si" : "No"}</div>
      ),
    },
    {
      field: "Telefono",
      headerName: "Celular",
      width: 150,
    },
    {
      field: "Ubicacion",
      headerName: "Propiedad Ingreso",
      width: 150,
    },
    {
      field: "FechaVisita",
      headerName: "Hora Ingreso",
      width: 150,
      renderCell: (params) => {
        const date = formatearFecha(params.row.FechaVisita);
        return <div>{date}</div>;
      },
    },
    {
      field: "FechaSalidaEstimada", //confirmar
      headerName: "Hora Salida",
      width: 150,
      renderCell: (params) => {
        const date = formatearFecha(params.row.FechaSalidaEstimada);
        return <div>{date}</div>;
      },
    },
    {
      field: "FechaSalidaEstimada",
      headerName: "Hora Estimada",
      width: 150,
      renderCell: (params) => {
        const date = formatearFecha(params.row.FechaSalidaEstimada);
        return <div>{date}</div>;
      },
    },
    {
      field: "Placa",
      headerName: "Placa",
      width: 150,
    },
    {
      field: "Observaciones",
      headerName: "Observaciones",
      width: 150,
    },
  ];
  // const { data } = useDemoData({
  //   dataSet: "Employee",
  //   visibleFields: VISIBLE_FIELDS,
  //   rowLength: 100,
  // });

  const [allBitacoraVisitas, setAllBitacoraVisitas] = useState([]);
  const getAllBitacoras = async () => {
    try {
      let allVisitas = await get("/visitas/obtenerAllBitacoraVisitas");
      console.log(allVisitas);
      setAllBitacoraVisitas(allVisitas);
    } catch (error) {
      console.error("No se pudo cargar las visitas");
    }
  };

  useEffect(() => {
    getAllBitacoras();
  }, []);

  return (
    <Layout>
      <div style={{ marginTop: "25px", paddingBottom: "25px" }}>
        <ModalVisita getAllBitacoras={getAllBitacoras} />
      </div>
      <div style={{ height: 400, width: "100%", minHeight: "85vh" }}>
        <DataGrid
          initialState={{
            pagination: { paginationModel: { pageSize: 10 } },
          }}
          pageSizeOptions={[10, 25, 100]}
          getRowId={(option) => option.Id}
          rows={allBitacoraVisitas}
          columns={columns}
          slots={{ toolbar: GridToolbar }}
        />
      </div>
    </Layout>
  );
};

export default VisitasPage;
