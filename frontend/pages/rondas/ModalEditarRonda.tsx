import * as React from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Modal from "@mui/material/Modal";
import { Input, Label, Textarea } from "@roketid/windmill-react-ui";
import { get, post } from "utils/services/api";
import { IconButton } from "@mui/material";
import SearchIcon from "@mui/icons-material/Search";
import TextField from "@mui/material/TextField";
import Autocomplete from "@mui/material/Autocomplete";
import CircularProgress from "@mui/material/CircularProgress";
import { set } from "date-fns";

const style = {
  position: "absolute" as "absolute",
  top: "50%",
  left: "50%",
  transform: "translate(-50%, -50%)",
  width: 840,
  bgcolor: "background.paper",
  borderRadius: "8px",
  boxShadow: 24,
  p: 4,
};

interface IPropiedades {
  Id: number;
  Codigo: string;
  Coordenadas: string;
  Tipo: string;
  FechaCrea: string;
  UsuarioCrea: number;
  FechaModifica: string;
  Descripcion: string;
  UsuarioModifica: number;
  Direccion: string;
  Estado: string;
}

export default function ModalEditarRonda({ currentRonda }) {
  const [open, setOpen] = React.useState(false);
  // Handle modal

  const handleOpen = () => setOpen(true);
  const handleClose = () => {
    cleanModalRonda(), setOpen(false);
  };

  const [ronda, setRonda] = React.useState({
    supervisores: [],
    ubicaciones: [],
    agentes: [],
  });

  const handleSetRonda = (value, data) => {
    setRonda((prev) => ({
      ...prev,
      [value]: data,
    }));
  };

  const [selectedValueCB, setSelectedValueCB] = React.useState({
    supervisor: currentRonda?.Supervisor,
    ubicacion: currentRonda?.Ubicacion,
    agente: null,
  });

  const handleSetSelectedValueCB = (value, data) => {
    setSelectedValueCB((prev) => ({
      ...prev,
      [value]: data,
    }));
  };

  //COMBOBOX SUPERVISOR
  const [isOpenSupervisorCB, setIsOpenSupervisorCB] = React.useState(false);
  const [isLoadingSupervisorCB, setIsLoadingSupervisorCB] =
    React.useState(false);

  //COMBOBOX UBICACION
  const [isOpenUbicacionCB, setIsOpenUbicacionCB] = React.useState(false);
  const [isLoadingUbicacionCB, setIsLoadingUbicacionCB] = React.useState(false);

  const getAllUbicaciones = async () => {
    setIsLoadingUbicacionCB(true);
    try {
      const response = await get("/rondas/getUbicaciones");
      handleSetRonda("ubicaciones", response);
    } catch (error) {
      alert("No se pudieron encontrar las ubicaciones");
    } finally {
      setIsLoadingUbicacionCB(false);
    }
  };

  React.useEffect(() => {
    getAllUbicaciones();
  }, []);

  const getAllSupervisores = async () => {
    setIsLoadingSupervisorCB(true);
    try {
      const response = await get(
        `/rondas/getSupervisoresxUbicacion/${selectedValueCB.ubicacion.id}`
      );
      handleSetRonda("supervisores", response);
    } catch (error) {
      alert("No se pudieron encontrar los supervisores");
    } finally {
      setIsLoadingSupervisorCB(false);
    }
  };

  // Esto lo hago porque necesito que se cargue el combobox de supervisor
  // solo en el primer redenrizado y luego en los otros cuando cambie
  // de ubicacion que el valor del combox de supervisor que cargue a null
  const [primerRenderizado, setPrimerRenderizado] = React.useState(true);

  React.useEffect(() => {
    if (primerRenderizado) setPrimerRenderizado(false);

    if (selectedValueCB.ubicacion) {
      if (!primerRenderizado) handleSetSelectedValueCB("supervisor", null);
      getAllSupervisores();
    }
  }, [selectedValueCB.ubicacion]);

  const editRonda = async () => {
    try {
      const payload = {
        IdRonda: currentRonda.Id,
        Desripcion: "",
        IdUbicacion: selectedValueCB?.ubicacion?.id,
        IdUsuarioSupervisor: selectedValueCB?.supervisor?.IdUsuario,
      };

      const response = await post("/rondas/editarRonda", payload);
      alert("Ronda actualizada");
    } catch (error) {
      alert("No se pudo actulizar la ronda");
    }
  };

  const cleanModalRonda = () => {
    setSelectedValueCB({
      supervisor: currentRonda?.Supervisor,
      ubicacion: currentRonda?.Ubicacion,
      agente: null,
    });
    setPrimerRenderizado(true);
  };

  const handleEdit = () => {
    const idUbicacion = selectedValueCB?.ubicacion?.id;
    const IdSupervisor = selectedValueCB?.supervisor?.IdUsuario;

    if (!idUbicacion || !IdSupervisor) {
      alert("Complete los campos");
      return;
    }

    editRonda();
    handleClose();
  };

  return (
    <div>
      <Button
        onClick={handleOpen}
        className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans py-1 px-4 rounded-lg mt-1"
      >
        Editar
      </Button>
      <Modal
        open={open}
        onClose={handleClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <Box sx={style}>
          <div className="flex justify-between">
            <h1 className="text-2xl font-sans font-semibold text-[#297DE2] mb-2">
              Editar Ronda
            </h1>
            <Button onClick={handleClose}>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="h-5 w-5 text-[#297DE2] hover:text-gray-700"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M6 18L18 6M6 6l12 12"
                />
              </svg>
            </Button>
          </div>

          <hr />

          <div style={{ margin: "0 auto" }}>
            {/* Ubicaciones */}
            <Autocomplete
              value={selectedValueCB.ubicacion}
              isOptionEqualToValue={(option, value) =>
                option.descripcion === value.descripcion
              } // Personaliza la comparación aquí
              style={{ width: "100%", marginTop: "25px", marginBottom: "20px" }}
              placeholder="Escoja un supervisor"
              id="asynchronous-demo"
              sx={{ width: 300 }}
              open={isOpenUbicacionCB}
              onOpen={() => {
                setIsOpenUbicacionCB(true);
              }}
              onClose={() => {
                setIsOpenUbicacionCB(false);
              }}
              getOptionLabel={(option) => {
                return option.descripcion;
              }}
              onChange={(event, option) => {
                handleSetSelectedValueCB("ubicacion", option);
              }}
              options={ronda.ubicaciones}
              loading={isLoadingUbicacionCB}
              renderInput={(params) => (
                <TextField
                  {...params}
                  label="Ubicación"
                  InputProps={{
                    ...params.InputProps,
                    endAdornment: (
                      <React.Fragment>
                        {isLoadingUbicacionCB ? (
                          <CircularProgress color="inherit" size={20} />
                        ) : null}
                        {params.InputProps.endAdornment}
                      </React.Fragment>
                    ),
                  }}
                />
              )}
            />

            {/* Supervisor */}
            <Autocomplete
              value={selectedValueCB.supervisor}
              style={{ width: "100%", marginBottom: "20px" }}
              placeholder="Escoja un supervisor"
              id="asynchronous-demo"
              sx={{ width: 300 }}
              open={isOpenSupervisorCB}
              onOpen={() => {
                setIsOpenSupervisorCB(true);
              }}
              onClose={() => {
                setIsOpenSupervisorCB(false);
              }}
              // filterOptions={customFilterOptions}
              getOptionLabel={(option) => {
                return option.Nombres + " " + option.Apellidos;
              }}
              onChange={(event, option) => {
                handleSetSelectedValueCB("supervisor", option);
              }}
              options={ronda.supervisores}
              loading={isLoadingSupervisorCB}
              renderInput={(params) => (
                <TextField
                  {...params}
                  label="Supervisor"
                  InputProps={{
                    ...params.InputProps,
                    endAdornment: (
                      <React.Fragment>
                        {isLoadingSupervisorCB ? (
                          <CircularProgress color="inherit" size={20} />
                        ) : null}
                        {params.InputProps.endAdornment}
                      </React.Fragment>
                    ),
                  }}
                />
              )}
            />
          </div>
          <div className="flex flex-row justify-center">
            <Button
              className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans py-1 px-6 rounded-lg mr-2"
              variant="contained"
              onClick={handleClose}
            >
              Cerrar
            </Button>
            <Button
              variant="contained"
              onClick={handleEdit}
              className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans py-1 px-6 rounded-lg"
            >
              Editar
            </Button>
          </div>
        </Box>
      </Modal>
    </div>
  );
}
