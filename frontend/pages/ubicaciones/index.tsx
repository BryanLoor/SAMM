import React, { useState, useEffect } from 'react';
import { get } from "utils/services/api";
import { DataGrid, GridColDef } from '@mui/x-data-grid';
import Layout from 'components/layout';
import RefreshSharpIcon from '@mui/icons-material/RefreshSharp';

interface Ubicacion {
  id: number;
  codigo: string;
  tipo: string;
  descripcion: string;
  fechaCrea: Date;
}

const Ubicaciones = () => {
    const [ubicaciones, setUbicaciones] = useState([]);
    const [fechaInicio, setFechaInicio] = useState(new Date());
    const [fechaFin, setFechaFin] = useState(new Date());

    const getUbicaciones = async () => {
        const response = await get('/rutas/getUbicaciones');
        setUbicaciones(response);
    };

    const handleFechaInicioChange = (event: ChangeEvent<HTMLInputElement>) => {
      const fechaInicio = Date.parse(event.target.value);
      setFechaInicio(fechaInicio);
  };

  const handleFechaFinChange = (event: { target: { value: React.SetStateAction<Date>; }; }) => {
      setFechaFin(event.target.value);
  };

    const handleFiltrar = () => {
        const ubicacionesFiltradas = ubicaciones.filter((ubicacion) => {
            return (
                ubicacion.fechaCrea >= fechaInicio &&
                ubicacion.fechaCrea <= fechaFin
            );
        });

        setUbicaciones(ubicacionesFiltradas);
    };

    useEffect(() => {
        getUbicaciones();
    }, []);

    const handleUbicacionClick = (id: any) => {
        window.location.href = `/ubicacion/${id}`;
    };

    const columns: GridColDef[] = [
      {
          field: 'id',
          headerName: 'Id',
          width: 80,
          headerClassName: 'super-app-theme--header',
          headerAlign: 'center',
      },
      {
          field: 'codigo',
          headerName: 'Código',
          width: 150,
      },
      {
          field: 'tipo',
          headerName: 'Tipo',
          width: 150,
      },
      {
          field: 'descripcion',
          headerName: 'Descripción',
          width: 200,
      },
    {
        field: 'fecha_crea',
        headerName: 'Fecha crea',
        width: 150,
    },
    {
        field: 'fecha_modifica',
        headerName: 'Fecha modifica',
        width: 150,
    },
    {
        field: 'hora_crea',
        headerName: 'Hora crea',
        width: 150,
    },
    {
        field: 'hora_modifica',
        headerName: 'Hora modifica',
        width: 150,
    },
  ];



    return (
      <Layout>
        <div>
        <div>
                <input type="date" name="fechaInicio" placeholder="Fecha inicio" onChange={handleFechaInicioChange} />
                <input type="date" name="fechaFin" placeholder="Fecha fin" onChange={handleFechaFinChange} />
                <button onClick={handleFiltrar}>Filtrar</button>
                <button onClick={getUbicaciones}> <RefreshSharpIcon /> </button>
            </div>
           
            <DataGrid
                rows={ubicaciones}
                columns={columns}
                onRowClick={handleUbicacionClick}
  
            />
          
        </div>
        </Layout>
    );
};

export default Ubicaciones;


