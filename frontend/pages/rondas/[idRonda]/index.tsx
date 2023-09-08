import { useState, useEffect } from "react";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import Layout from "components/layout";
import { get } from "utils/services/api";
import { useRouter } from "next/router";

const columns = [
  {
    field: "Id",
    headerName: "Id",
    width: 100,
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

const Index = () => {
  const router = useRouter();
  const { idRonda } = router.query;
  const [allRondasPuntos, setAllRondasPuntos] = useState([]);

  const getAllRondas = async () => {
    try {
      const data = await get(`/rondas/getRonda/${idRonda}`);
      setAllRondasPuntos(data.data);
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
      <div>
        <div style={{ height: 400, width: "100%", minHeight: "85vh" }}>
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
      </div>
    </Layout>
  );
};
export default Index;
