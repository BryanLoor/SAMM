import { useState, useEffect } from "react";
import { Input, Label, Select } from "@roketid/windmill-react-ui";
import { Modal, Button, Box, Autocomplete, TextField } from "@mui/material";
import CircularProgress from "@mui/material/CircularProgress";
import { get, put } from "utils/services/api";

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

const OPTIONS_ESTADO = [
  {
    value: "A",
    label: "Activo",
  },
  {
    value: "I",
    label: "Inactivo",
  },
];

const ModalUpadateRol = ({
  openModalUpadateRol,
  setOpenModalUpadateRol,
  row,
  updateAllInfoRoles,
}) => {
  const [open, setOpen] = [openModalUpadateRol, setOpenModalUpadateRol];
  const handleClose = () => setOpen(false);
  const [infoRolToUpadte, setInfoRolToUpadte] = useState({
    codigo: "",
    estado: "",
    descripcion: "",
  });
  const [loadingSaveBtn, setLoadingSaveBtn] = useState(false);

  //Poner en el modal lo valores por defecto del
  //nuevo row clickeado
  useEffect(() => {
    setInfoRolToUpadte((prev) => ({
      ...prev,
      idRol: row.Id,
      codigo: row.Codigo,
      estado: row.Estado,
      descripcion: row.Descripcion,
    }));
  }, [row]);

  //   console.log(row, infoRolToUpadte, "rrrrrrrrrrrrr");

  const handleSave = async () => {
    try {
      setLoadingSaveBtn(true);
      const response = await put(
        `/visitas/roles/${infoRolToUpadte.idRol}`,
        infoRolToUpadte
      );
      const result = await get("/visitas/roles");
      updateAllInfoRoles(result["roles"]);
      console.log(response, "aqui");
      setInfoRolToUpadte(infoRolToUpadte);
      setLoadingSaveBtn(false);
    } catch (error) {
      console.error(error, "error");
    }
  };

  return (
    <div>
      <Modal
        open={open}
        onClose={handleClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <Box sx={style}>
          <div className="flex justify-between">
            <h1 className="text-2xl font-sans font-semibold text-[#297DE2] mb-2">
              Actualización de rol
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
          <div className="flex flex-col overflow-y-auto md:flex-column">
            <main className="flex items-center justify-center sm:p-4 md:w-1/1">
              <div className="w-80">
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Codigo
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese código del rol"
                    value={infoRolToUpadte.codigo}
                    onChange={(e) => {
                      setInfoRolToUpadte((prev) => ({
                        ...prev,
                        codigo: e.target.value,
                      }));
                    }}
                  />
                </Label>
              </div>
            </main>
            <main className="flex items-center justify-center sm:p-4 md:w-1/1">
              <div className="w-80 font-sans">
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Estado
                  </span>
                  <Select
                    value={
                      infoRolToUpadte.estado === "A" ? "Actio" : "Inactivo"
                    }
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    onChange={(e) => {
                      setInfoRolToUpadte((prev) => ({
                        ...prev,
                        estado: e.target.value === "Activo" ? "A" : "I",
                      }));
                    }}
                  >
                    <option>Activo</option>
                    <option>Inactivo</option>
                  </Select>
                </Label>
              </div>
            </main>
            <main className="flex items-center justify-center sm:p-4 md:w-1/1">
              <div className="w-80 font-sans">
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Descripcion
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese la descripción"
                    value={infoRolToUpadte.descripcion}
                    onChange={(e) => {
                      setInfoRolToUpadte((prev) => ({
                        ...prev,
                        descripcion: e.target.value,
                      }));
                    }}
                  />
                </Label>
              </div>
            </main>
          </div>
          <div className="flex flex-row justify-center mt-7">
            <Button
              className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans py-1 px-6 rounded-lg mr-2"
              variant="contained"
              onClick={handleClose}
            >
              Cerrar
            </Button>
            <Button
              disabled={loadingSaveBtn}
              variant="contained"
              onClick={handleSave}
              className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans py-1 px-6 rounded-lg"
            >
              {loadingSaveBtn ? <CircularProgress size={20} /> : "Guardar"}
            </Button>
          </div>
        </Box>
      </Modal>
    </div>
  );
};

export default ModalUpadateRol;
