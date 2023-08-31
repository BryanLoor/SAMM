import * as React from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Modal from "@mui/material/Modal";
import { Input, Label } from "@roketid/windmill-react-ui";
import { get, post } from "utils/services/api";
import { MenuItem, Select } from "@mui/material";

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

export default function ModalPersonas() {
  const [open, setOpen] = React.useState(false);
  const [selectedPropiedad, setSelectedPropiedad] = React.useState("");
  const [propiedades, setPropiedades] = React.useState<IPropiedades[]>([]);
  const [codigo, setCodigo] = React.useState("");
  const [descripcion, setDescripcion] = React.useState("");
  const [tiempoEstadia, setTiempoEstadia] = React.useState("");
  const [placa, setPlaca] = React.useState("");
  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);

  React.useEffect(() => {
    const fetchData = async () => {
      const result = await get("/visitas/getUrbanizaciones");
      console.log(result);
      setPropiedades(result);
    };
    fetchData();
  }, []);

  function convertTo12Hour(time: any) {
    const [hours, minutes] = time.split(":");
    let formattedHours = parseInt(hours, 10);
    let meridiem = "AM";

    if (formattedHours === 0) {
      formattedHours = 12;
    } else if (formattedHours === 12) {
      meridiem = "PM";
    } else if (formattedHours > 12) {
      formattedHours -= 12;
      meridiem = "PM";
    }

    return { hours: formattedHours, minutes: parseInt(minutes, 10), meridiem };
  }

  // Btn Guardar
  const handleSave = () => {
    const tE = convertTo12Hour(tiempoEstadia);
    console.log(tiempoEstadia);
    const loadData = {
      Codigo: codigo,
      Descripcion: descripcion,
    };
    const response = async () => {
      const result = await post("/visitas/crearPersona", loadData);
      console.log(result);
    };
    response();
    console.log("Guardar datos de la visita");
    handleClose();
  };

  return (
    <div>
      <Button
        onClick={handleOpen}
        className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans py-1 px-4 rounded-lg mt-1"
      >
        Crear persona
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
              Nueva persona
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
              <div className="w-80">
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Identificación
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese una identificación"
                    // value={codigo}
                    // onChange={(e) => {
                    //   setCodigo(e.target.value);
                    // }}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Teléfono domicilio
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese un teléfono"
                    // value={codigo}
                    // onChange={(e) => {
                    //   setCodigo(e.target.value);
                    // }}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Correo domicilio
                  </span>
                  <Input
                    type="email"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese un correo"
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
                    Dirección domicilio
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese una dirección"
                    // value={descripcion}
                    // onChange={(e) => {
                    //   setDescripcion(e.target.value);
                    // }}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Celular personal
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese un numero de celular"
                    // value={descripcion}
                    // onChange={(e) => {
                    //   setDescripcion(e.target.value);
                    // }}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Cargo
                  </span>
                  <br />
                  <Select
                    // value={alerta}
                    // onChange={(event) => setAlerta(event.target.value)}
                    className="h-[38px] w-80 bg-blue-200 text-sm"
                    placeholder="Seleccione un cargo"
                  >
                    <MenuItem value="">
                      <b>Seleccionar cargo</b>
                    </MenuItem>
                    <hr />
                    <MenuItem value="administrador">Administrador</MenuItem>
                    <MenuItem value="supervisor">Supervisor</MenuItem>
                    <MenuItem value="agente">Agente</MenuItem>
                  </Select>
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
              onClick={handleSave}
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
