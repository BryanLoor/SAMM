import { useEffect, useState } from "react";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import { useDemoData } from "@mui/x-data-grid-generator";
import Layout from "components/layout";
import ModalVisita from "./modal-crear-visita";
import { get, put } from "utils/services/api";
import { Button } from "@mui/material";
import ButtonExcelDownload from "components/ButtonExcelDownload";

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
  // Crear un objeto Date a partir de la fecha original
  const fechaOriginal = new Date(date);

  // Establecer la zona horaria local de Ecuador
  const zonaHorariaEcuador = "America/Guayaquil";
  fechaOriginal.setTime(
    fechaOriginal.getTime() + fechaOriginal.getTimezoneOffset() * 60 * 1000
  );

  // Formatear la fecha en un formato personalizado (por ejemplo, "31 de agosto de 2023, 20:41")
  const options = {
    timeZone: zonaHorariaEcuador,
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "numeric",
    minute: "numeric",
  };

  const fechaFormateada = fechaOriginal.toLocaleString("es-EC", options);
  return fechaFormateada;

  // return fechaOriginal
};

const VisitasPage = () => {
  const marcarLlegada = async (idBitacoraVisita) => {
    try {
      await put(`/visitas/marcarLlegadaReal/${idBitacoraVisita}`, {});
      await getAllBitacoras();
    } catch (error) {
      alert("No se pudo registrar la hora de llegada");
    }
  };

  const marcarSalida = async (idBitacoraVisita) => {
    console.log(idBitacoraVisita);
    try {
      await put(`/visitas/marcarSalidaReal/${idBitacoraVisita}`, {});
      await getAllBitacoras();
    } catch (error) {
      alert("No se pudo registrar la hora de salida");
    }
  };

  const columns = [
    { field: "Id", headerName: "ID", width: 90 },
    // {
    //   field: "",
    //   headerName: "Edición",
    //   width: 90,
    //   renderCell: (params) => {
    //     return (
    //       <ModalEditarVisita
    //         visita={params.row}
    //         detectVistaStatus={detectVistaStatus}
    //         getAllBitacoras={getAllBitacoras}
    //       />
    //     );
    //   },
    // },
    {
      field: "Estado",
      headerName: "Status visita",
      width: 100,
    },
    {
      field: "FechaTimeVisitaEstimada",
      headerName: "Fecha de llegada agendada",
      width: 250,
      renderCell: (params) => {
        if (params.row.FechaTimeVisitaEstimada) {
          const date = formatearFecha(params.row.FechaTimeVisitaEstimada);
          return <div>{date}</div>;
        } else {
          return <div>No existe fecha</div>;
        }
      },
    },
    {
      field: "FechaTimeVisitaReal",
      headerName: "Fecha de llegada marcada",
      width: 250,
      renderCell: (params) => {
        console.log(params.row.FechaTimeVisitaReal, "--------");
        if (params.row.FechaTimeVisitaReal) {
          const date = formatearFecha(params.row.FechaTimeVisitaReal);
          return <div>{date}</div>;
        } else {
          return (
            <div style={{ margin: "0 auto" }}>
              <button
                style={{
                  color: "white",
                  background: "#1e6479",
                  padding: "6px",
                  borderRadius: "5px",
                }}
                onClick={() => marcarLlegada(params.row.Id)}
              >
                Marcar llegada
              </button>
            </div>
          );
        }
      },
    },
    {
      field: "FechaTimeSalidaEstimada",
      headerName: "Fecha de salida agendada",
      width: 250,
      renderCell: (params) => {
        if (params.row.FechaTimeSalidaEstimada) {
          const date = formatearFecha(params.row.FechaTimeSalidaEstimada);
          return <div>{date}</div>;
        } else {
          return <div>No existe fecha</div>;
        }
      },
    },
    {
      field: "FechaTimeSalidaReal",
      headerName: "Fecha de salida marcada",
      width: 250,
      renderCell: (params) => {
        if (params.row.FechaTimeSalidaReal) {
          const date = formatearFecha(params.row.FechaTimeSalidaReal);
          return <div>{date}</div>;
        } else {
          return (
            <div style={{ margin: "0 auto" }}>
              <button
                style={{
                  color: "white",
                  background: "#1e6479",
                  padding: "6px",
                  borderRadius: "5px",
                }}
                onClick={() => marcarSalida(params.row.Id)}
              >
                Marcar salida
              </button>
            </div>
          );
        }
      },
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
      field: "NombresVisitante",
      headerName: "Nombres Visitante",
      width: 150,
    },
    {
      field: "ApellidosVisitante",
      headerName: "Apellidos Visitante",
      width: 150,
    },
    {
      field: "IdentificacionAnfitrion",
      headerName: "Identificacion Anfitrión",
      width: 150,
    },
    {
      field: "IdentificacionVisitante",
      headerName: "Identificacion Visitante",
      width: 150,
    },
    {
      field: "Antecedentes Penales",
      headerName: "Antecedentes Penales",
      width: 150,
      renderCell: (params) => (
        <div>{params.row.AntecdentesPenales ? "Si" : "No"}</div>
      ),
    },
    {
      field: "Ubicacion",
      headerName: "Propiedad",
      width: 150,
    },

    {
      field: "Celular",
      headerName: "Celular",
      width: 150,
    },
    {
      field: "Correo",
      headerName: "Correo",
      width: 150,
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
      let allVisitas = await get("/visitas/getAllBitacoraVisitas");
      console.log(allVisitas);
      setAllBitacoraVisitas(allVisitas.data);
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
        <ButtonExcelDownload data={allBitacoraVisitas} />
      </div>
      <div
        style={{
          height: 400,
          width: "1200px",
          minHeight: "85vh",
          alignSelf: "center",
        }}
      >
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
