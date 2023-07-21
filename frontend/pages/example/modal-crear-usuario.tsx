import * as React from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Modal from "@mui/material/Modal";
import { Input, Label } from "@roketid/windmill-react-ui";
import { get, post } from "utils/services/api";

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

export default function ModalUsuario() {
  const [open, setOpen] = React.useState(false);
  const [selectedPropiedad, setSelectedPropiedad] = React.useState("");
  const [propiedades, setPropiedades] = React.useState([] as IPropiedades[]);
  const [cedulaVisitante, setCedulaVisitante] = React.useState("");
  const [nombresCompletos, setNombresCompletos] = React.useState("");
  const [apellidosCompletos, setApellidosCompletos] = React.useState("");
  const [fechaVisita, setFechaVisita] = React.useState("");
  const [horaIngreso, setHoraIngreso] = React.useState("");
  const [tiempoEstadia, setTiempoEstadia] = React.useState("");
  const [celular, setCelular] = React.useState("");
  const [correo, setCorreo] = React.useState("");
  const [cargo, setCargo] = React.useState("");
  const [ubicacion, setUbicacion] = React.useState("");
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
    // Lógica para guardar los datos de la visita
    // Puedes implementar tu propia lógica aquí
    // make 12:05 tiempoEstadia a number
    const tE = convertTo12Hour(tiempoEstadia);
    console.log(tiempoEstadia);
    const loadData = {
      nombres: nombresCompletos,
      apellidos: apellidosCompletos,
      cedula: cedulaVisitante, 
    };
    const response = async () => {
      const result = await post("/visitas/registraVisita", loadData);
      console.log(result);
    };
    response();
    console.log("Guardar datos de la visita");
    handleClose();
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

  return (
    <div>
      <Button
        onClick={handleOpen}
        className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans py-1 px-4 rounded-lg mt-1"
      >
        Crear Usuario
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
              Nuevo usuario
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
                <Label>
                  <span className="font-sans text-[#001554] font-semibold">
                    Nombres completos
                  </span>
                  <Input
                    type="search"
                    className="mt-1 bg-[#297DE240] text-[16px]"
                    placeholder="Ingrese los nombres completos"
                    // value={cedulaVisitante}
                    // onChange={(e) => {
                    //   setCedulaVisitante(e.target.value);
                    // }}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Apellidos completos
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese los apellidos completos"
                    // value={nombresCompletos}
                    // onChange={(e) => {
                    //   setNombresCompletos(e.target.value);
                    // }}
                  />
                </Label>
                <Label className="mt-4 ">
                  <span className="font-sans text-[#001554] font-semibold">
                    Identificación
                  </span>
                  <Input
                    typeof="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    type="email"
                    placeholder="Ingrese la identificación"
                    // value={apellidosCompletos}
                    // onChange={(e) => {
                    //   setApellidosCompletos(e.target.value);
                    // }}
                  />
                </Label>
                <Label className="mt-4 ">
                  <span className="font-sans text-[#001554] font-semibold">
                    Celular
                  </span>
                  <Input
                    typeof="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    type="email"
                    placeholder="Ingrese el número de celular"
                    // value={apellidosCompletos}
                    // onChange={(e) => {
                    //   setApellidosCompletos(e.target.value);
                    // }}
                  />
                </Label>
              </div>
            </main>
            <main className="flex items-center justify-center sm:p-4 md:w-2/2">
              <div className="w-80 font-sans">
                <Label className="">
                  <span className="font-sans text-[#001554] font-semibold">
                    Correo electrónico
                  </span>
                  <Input
                    type="email"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese el correo electrónico"
                    // value={fechaVisita}
                    // onChange={(e) => {
                    //   setFechaVisita(e.target.value);
                    // }}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Roles<br/>
                  </span>
                  <select 
                  className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                  >
                    <option value="volvo">Seleccione un rol</option>
                    <option value="1">Administrador</option>
                    <option value="3">Agente</option>
                    <option value="4">Supervisor</option>
                  </select>

                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Cargos
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese los cargos"
                    // value={tiempoEstadia}
                    // onChange={(e) => {
                    //   setTiempoEstadia(e.target.value);
                    // }}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Ubicación o lugar de trabajo
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese la ubicación o lugar de trabajo"
                    // value={tiempoEstadia}
                    // onChange={(e) => {
                    //   setTiempoEstadia(e.target.value);
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
