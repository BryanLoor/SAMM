import { useState, useEffect, useContext } from "react";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import Layout from "components/layout";
import { get } from "utils/services/api";
import { useRouter } from "next/router";
import { GlobalContext } from "context/GlobalContext";
import { FcRefresh } from "react-icons/fc";
import ModalCrearPuntoRonda from "./modal-crear-PuntoRonda";
import ModalEditarPuntoRonda from "./modal-editar-puntoRonda";

const PuntosDeRonda = () => {
  const router = useRouter();
  const { idRonda } = router.query;
  const [allRondasPuntos, setAllRondasPuntos] = useState([]);
  const columns = [
    {
      field: "Id",
      headerName: "Id",
      width: 100,
    },
    {
      field: "",
      headerName: "Edición",
      width: 110,
      renderCell: (params) => {
        const selectedPuntoRonda = allRondasPuntos.find(
          (ronda) => ronda?.Id === params?.row?.Id
        );
        console.log(selectedPuntoRonda, allRondasPuntos);
        return <ModalEditarPuntoRonda currentPuntoRonda={selectedPuntoRonda} />;
      },
    },
    {
      field: "IdRonda",
      headerName: "IdRonda",
      width: 120,
    },
    {
      field: "Orden",
      headerName: "Orden",
      width: 120,
    },
    {
      field: "Coordenada",
      headerName: "Coordenada",
      width: 150,
    },
    {
      field: "Descripcion",
      headerName: "Descripcion",
      width: 200,
    },
    {
      field: "NameEstado",
      headerName: "Estado",
      width: 120,
    },
    {
      field: "FechaCreacion",
      headerName: "Fecha Creación",
      width: 150,
    },
    {
      field: "UsuCreacion",
      headerName: "Usuario Creación",
      width: 150,
    },
    {
      field: "FechaModificacion",
      headerName: "Fecha Modificación",
      width: 180,
    },
    {
      field: "UsuModifica",
      headerName: "Usuario Modificación",
      width: 180,
    },
    {
      field: "NameUsuModifica",
      headerName: "Nombre Usuario Modificación",
      width: 220,
    },
  ];

  const getAllPuntosRonda = async () => {
    try {
      const data = await get(`/rondaPunto/getRondaPuntosxRonda/${idRonda}`);
      setAllRondasPuntos(data.data);
      console.log(data.length);
    } catch (error) {
      alert("No se puedo obtener los puntos de la ronda");
    }
  };

  useEffect(() => {
    try {
      getAllPuntosRonda();
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
          <ModalCrearPuntoRonda />
          <div style={{ marginTop: "10px" }}>
            <span
              onClick={getAllPuntosRonda}
              style={{ cursor: "pointer" }}
              title="Recargar"
            >
              <FcRefresh size={28} />
            </span>
          </div>
          <b>Puntos de ronda {idRonda}</b>
        </div>
        <DataGrid
          initialState={{
            pagination: { paginationModel: { pageSize: 10 } },
          }}
          pageSizeOptions={[10, 25, 100]}
          getRowId={(option) => option.Id}
          rows={allRondasPuntos}
          columns={columns}
          slots={{ toolbar: GridToolbar }}
        />
      </div>
    </Layout>
  );
};
export default PuntosDeRonda;
