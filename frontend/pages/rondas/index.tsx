import { useState, useEffect, useContext } from "react";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import Layout from "components/layout";
import { get } from "utils/services/api";
import Link from "next/link";
import { Button } from "@mui/material";
import ModalEditarRonda from "./ModalEditarRonda";
import { GlobalContext } from "context/GlobalContext";
import ModalCrearRonda from "./modal-crear-ronda";
import { FcRefresh } from "react-icons/fc";

const Index = () => {
  const columns = [
    {
      field: "Id",
      headerName: "Id",
      width: 100,
      renderCell: (params) => {
        const { setRondaSelected } = useContext(GlobalContext);

        const selectedRonda = allRondas.find(
          (ronda) => ronda?.Id === params?.row?.Id
        );
        setRondaSelected(selectedRonda);

        return (
          <Link href={`/rondas/${params.row.Id}`}>
            <Button className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans py-1 px-6 rounded-lg">
              {params.row.Id}
            </Button>
          </Link>
        );
      },
    },
    {
      field: "",
      headerName: "Edición",
      width: 110,
      renderCell: (params) => {
        const selectedRonda = allRondas.find(
          (ronda) => ronda?.Id === params?.row?.Id
        );
        console.log(selectedRonda, allRondas);
        return <ModalEditarRonda currentRonda={selectedRonda} />;
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
        }}
      >
        <div style={{ marginTop: "25px", paddingBottom: "25px" }}>
          <ModalCrearRonda />
          <div style={{ marginTop: "10px" }}>
            <span
              onClick={getAllRondas}
              style={{ cursor: "pointer" }}
              title="Recargar"
            >
              <FcRefresh size={28} />
            </span>
          </div>
        </div>
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
