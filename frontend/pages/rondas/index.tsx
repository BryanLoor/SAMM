import { useState, useEffect, useContext } from "react";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import Layout from "components/layout";
import { get } from "utils/services/api";
import Link from "next/link";
import { Button } from "@mui/material";
import ModalEditarRonda from "./ModalEditarRonda";
import { GlobalContext } from "context/GlobalContext";
const columns = [
  {
    field: "Id",
    headerName: "Id",
    width: 100,
    renderCell: (params) => {
      const { setRondaSelected } = useContext(GlobalContext);
      setRondaSelected(params.row);

      return (
        <Link href={`/rondas/${params.row.Id}`}>
          <Button variant="contained">{params.row.Id}</Button>
        </Link>
      );
    },
  },
  {
    field: "",
    headerName: "Edición",
    width: 90,
    renderCell: (params) => {
      return (
        <ModalEditarRonda visita={params.row} getAllBitacoras={() => {}} />
      );
    },
  },
  {
    field: "IdUsuarioSupervisor",
    headerName: "IdUsuarioSupervisor",
    width: 100,
  },
  {
    field: "NombreSupervisor",
    headerName: "Nombre del Supervisor",
    width: 200,
  },
  {
    field: "Estado",
    headerName: "Estado",
    width: 100,
  },
  {
    field: "IdUbicacion",
    headerName: "IdUbicacion",
    width: 100,
  },
  {
    field: "NameUbicacion",
    headerName: "Nombre de la Ubicación",
    width: 200,
  },
  {
    field: "FechaCreacion",
    headerName: "Fecha de Creación",
    width: 250,
  },
  {
    field: "FechaModifica",
    headerName: "Fecha de Modificación",
    width: 250,
  },
];

const Index = () => {
  const [allRondas, setAllRondas] = useState([]);

  const getAllRondas = async () => {
    try {
      const data = await get("/rondas/getAllRondas");
      setAllRondas(data.data);
      console.log(data.length);
    } catch (error) {
      alert("No se puedo obtener las rondas");
    }
  };

  useEffect(() => {
    try {
      getAllRondas();
    } catch (error) {
      console.error(error);
    }
  }, []);

  return (
    <Layout>
      <div
        style={{
          height: 400,
          width: "1200px",
          minHeight: "85vh",
          alignSelf: "center",
          marginTop: "50px",
        }}
      >
        <DataGrid
          initialState={{
            pagination: { paginationModel: { pageSize: 10 } },
          }}
          pageSizeOptions={[10, 25, 100]}
          getRowId={(option) => option.Id}
          rows={allRondas}
          columns={columns}
          slots={{ toolbar: GridToolbar }}
        />
      </div>
    </Layout>
  );
};
export default Index;
