import * as React from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Modal from "@mui/material/Modal";
import { Input, Label } from "@roketid/windmill-react-ui";
import SectionTitle from "example/components/Typography/SectionTitle";
import PageTitle from "example/components/Typography/PageTitle";

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

export default function ModalRonda() {
  const [open, setOpen] = React.useState(false);
  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);

  // Btn Guardar
  const handleSave = () => {
    // Lógica para guardar los datos de la visita
    // Puedes implementar tu propia lógica aquí
    console.log("Guardar datos de la visita");
    handleClose();
  };

  return (
    <div>
      <button
        className="font-sans font-medium text-[#297DE2]"
        onClick={handleOpen}
      >
        Ver
        <hr className="border-[#297DE2]" />
      </button>

      <Modal
        open={open}
        onClose={handleClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <Box sx={style}>
          <div className="flex justify-between">
            <h1 className="text-2xl font-sans font-semibold text-[#0040AE] mb-2">
              Punto 1
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

          <div className="flex flex-col overflow-y-auto md:flex-row">
            <main className="flex items-center justify-center sm:p-4 md:w-1/2">
              <div className="w-80 text-center">
                <Label className="mt-4 ">
                  <h1 className="text-xl font-sans text-[#297DE2]">Registro</h1>
                  <h2 className="text-2xl font-sans font-semibold text-[#001554]">
                    Observaciones
                  </h2>
                  <p className="text-base font-sans mt-6 text-[#001554]">
                    Urb. Pacho Salas Punto: 1 - Casa 15A
                  </p>
                </Label>
              </div>
            </main>
            <main className="flex items-center justify-center sm:p-4 md:w-2/2">
              <div className="w-80 font-sans text-center">
                <Label className="mt-4 ">
                  <h1 className="text-xl font-sans text-[#297DE2]">Registro</h1>
                  <h2 className="text-2xl font-sans font-semibold text-[#001554]">
                    Imágenes
                  </h2>
                  <p className="text-base font-sans mt-6 text-[#001554]">
                    Urb. Pacho Salas Punto: 1 - Casa 15A
                  </p>
                </Label>
              </div>
            </main>
          </div>
        </Box>
      </Modal>
    </div>
  );
}
