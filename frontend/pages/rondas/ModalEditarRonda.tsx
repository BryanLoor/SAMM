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

export default function ModalEditarRonda() {
  const [open, setOpen] = React.useState(false);

  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);

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
            {/* <main className="flex items-center justify-center sm:p-4 md:w-1/2"> */}
            <div>
              {/* Ubicaciones */}
              {/* <Autocomplete
                style={{ width: "100%" }}
                placeholder="Escoja una ubicacion"
                id="asynchronous-demo"
                sx={{ width: 300, marginBottom: "1rem" }}
                open={openCBUbicacion}
                onOpen={() => {
                  setOpenCBUbicacion(true);
                }}
                onClose={() => {
                  setOpenCBUbicacion(false);
                }}
                // filterOptions={customFilterOptions}
                getOptionLabel={(option) => option?.Descripcion}
                onChange={(event, option) => {
                  setIdUbicacionSelected(option?.Id);
                }}
                options={allUbicaciones}
                loading={isLoadingCBUbicacion}
                renderInput={(params) => (
                  <TextField
                    {...params}
                    label="Ubicación"
                    InputProps={{
                      ...params.InputProps,
                      endAdornment: (
                        <React.Fragment>
                          {isLoadingCBUbicacion ? (
                            <CircularProgress color="inherit" size={20} />
                          ) : null}
                          {params.InputProps.endAdornment}
                        </React.Fragment>
                      ),
                    }}
                  />
                )}
              /> */}
            </div>
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
              // onClick={handleSave}
              className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans py-1 px-6 rounded-lg"
            >
              Guardar
            </Button>
          </div>
        </Box>
      </Modal>
    </div>
  );
}
