import { useState } from "react";
import { Modal, Button, Box } from "@mui/material";
import { Input, Label } from "@roketid/windmill-react-ui";
import QuickFilteringGrid from "components/user";

// api
// [
//   {
//     id: 1,
//     name: "Jhon",
//     roles: [
//       {
//         id: 1,
//         codigo: "visitante",
//       },
//       {
//         id: 2,
//         codigo: "anfitrion",
//       },
//       {
//         id: 3,
//         codigo: "supervisor",
//       },
//     ],
//   },
//   {
//     id: 2,
//     name: "Maria",
//     roles: [
//       {
//         id: 1,
//         codigo: "visitante",
//       },
//       {
//         id: 2,
//         codigo: "anfitrion",
//       },
//       {
//         id: 3,
//         codigo: "supervisor",
//       },
//     ],
//   },
// ];

// [
//   {
//     id:"1",
//     codigo:"visitante"
//   },
//   {
//     id:"2",
//     codigo:"anfitrion"
//   }
// ]

const style = {
  position: "absolute",
  top: "50%",
  left: "50%",
  transform: "translate(-50%, -50%)",
  width: 840,
  bgcolor: "background.paper",
  borderRadius: "8px",
  boxShadow: 24,
  p: 4,
};

const ModalAssignRol = () => {
  const [open, setOpen] = useState(false);

  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);
  return (
    <div>
      <Button
        onClick={handleOpen}
        className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans py-1 px-4 rounded-lg mt-1"
      >
        Asignar rol
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
              Asignación de rol
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
          <QuickFilteringGrid />
          <div className="flex flex-col overflow-y-auto md:flex-row">
            <main className="flex items-center justify-center sm:p-4 md:w-1/2">
              <div className="w-80">
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Codigooo
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese código del rol"
                    // value={codigo}
                    // onChange={(e) => {
                    //   setCodigo(e.target.value);
                    // }}
                  />
                </Label>
              </div>
            </main>
            <main className="flex items-center justify-center sm:p-4 md:w-2/2">
              <div className="w-80 font-sans">
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Descripcion
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese los roles"
                    // value={descripcion}
                    // onChange={(e) => {
                    //   setDescripcion(e.target.value);
                    // }}
                  />
                </Label>
              </div>
            </main>
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
              //   onClick={handleSave}
              className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans py-1 px-6 rounded-lg"
            >
              Guardar
            </Button>
          </div>
        </Box>
      </Modal>
    </div>
  );
};

export default ModalAssignRol;
