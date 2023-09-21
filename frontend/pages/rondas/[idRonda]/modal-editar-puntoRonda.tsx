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

import { styled } from "@mui/material";
import { GlobalContext } from "context/GlobalContext";
import { useRouter } from "next/router";

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
const TextFieldStyled = styled(TextField)(({ theme }) => ({
  backgroundColor: theme.palette.background.default,
  border: `1px solid ${theme.palette.divider}`,
  borderRadius: theme.shape.borderRadius,
  padding: theme.spacing(1),
  "&:hover": {
    borderColor: theme.palette.primary.main,
  },
  "&:focus": {
    borderColor: theme.palette.primary.main,
  },
}));

export default function ModalEditarPuntoRonda({ currentPuntoRonda }) {
  const router = useRouter();
  const { idRonda } = router.query;

  const [open, setOpen] = React.useState(false);
  // Handle modal

  const handleOpen = () => setOpen(true);
  const handleClose = () => {
    cleanModalPuntoRonda(), setOpen(false);
  };

  const [puntoRonda, setPuntoRonda] = React.useState({
    coordenada: currentPuntoRonda.Coordenada,
    descripcion: currentPuntoRonda.Descripcion,
    orden: currentPuntoRonda.Orden,
  });

  const handleSetPuntoRonda = (value, data) => {
    setPuntoRonda((prev) => ({
      ...prev,
      [value]: data,
    }));
  };

  const editPuntoRonda = async () => {
    try {
      const payload = {
        IdPuntoRonda: currentPuntoRonda.Id,
        Coordenada: puntoRonda.coordenada,
        Descripcion: puntoRonda.descripcion,
        Orden: puntoRonda.orden,
      };
      console.log(payload);

      const response = await post("/rondaPunto/updateRondaPunto", payload);
      alert("PuntoRonda creada");
    } catch (error) {
      alert("No se pudo editar el PuntoRonda");
    }
  };

  const cleanModalPuntoRonda = () => {
    setPuntoRonda({
      coordenada: currentPuntoRonda.Coordenada,
      descripcion: currentPuntoRonda.Descripcion,
      orden: currentPuntoRonda.Orden,
    });
  };

  const handleEdit = () => {
    const coordenada = puntoRonda.coordenada;
    const descripcion = puntoRonda.descripcion;
    const orden = puntoRonda.orden;

    if (!coordenada || !descripcion || !orden) {
      alert("Complete los campos");
      return;
    }

    editPuntoRonda();
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
              Editar PuntoRonda
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
            {/* Coordeanda */}
            <TextFieldStyled
              fullWidth
              style={{
                width: "100%",
                marginTop: "25px",
                marginBottom: "20px",
              }}
              id="outlined-controlled"
              label="Coordenada"
              value={puntoRonda.coordenada}
              onChange={(event) => {
                handleSetPuntoRonda("coordenada", event.target.value);
              }}
            />

            {/* Descripcion */}
            <TextFieldStyled
              fullWidth
              style={{
                width: "100%",
                marginBottom: "20px",
              }}
              id="outlined-controlled"
              label="Descripción"
              value={puntoRonda.descripcion}
              onChange={(event) => {
                handleSetPuntoRonda("descripcion", event.target.value);
              }}
            />

            {/* Orden */}
            <TextFieldStyled
              fullWidth
              style={{
                width: "100%",
                marginBottom: "20px",
              }}
              id="outlined-controlled"
              label="Orden"
              value={puntoRonda.orden}
              onChange={(event) => {
                handleSetPuntoRonda("orden", event.target.value);
              }}
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
