import * as React from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Modal from "@mui/material/Modal";
import { Alert, AlertTitle } from "@mui/material";
import { Input, Label } from "@roketid/windmill-react-ui";
import { get, post } from "utils/services/api";
import { Autocomplete } from "@mui/material";
import LocationOnIcon from "@mui/icons-material/LocationOn";
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

export default function ModalPropiedad() {
  const [open, setOpen] = React.useState(false);
  const [selectedPropiedad, setSelectedPropiedad] = React.useState("");
  const [propiedades, setPropiedades] = React.useState([] as IPropiedades[]);
  const [cedulaVisitante, setCedulaVisitante] = React.useState("");
  const [direccion, setDireccion] = React.useState("");
  const [celularAdministracion, setCelularAdministracion] = React.useState("");
  const [cantidadPropiedades, setCantidadPropiedades] = React.useState(0);

  const [tiempoEstadia, setTiempoEstadia] = React.useState("");
  const [agentes, setAgentes] = React.useState([] as any[]);
  const [supervisores, setSupervisores] = React.useState([] as any[]);
  const [selectedAgentes, setSelectedAgentes] = React.useState<string[]>([]);
  const [placa, setPlaca] = React.useState("");
  const [selectedSupervisor, setSelectedSupervisor] = React.useState("");
  const [coordenadas, setCoordenadas] = React.useState("");
  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);
  const [alert, setAlert] = React.useState({
    type: "",
    title: "",
  });

  React.useEffect(() => {
    const fetchAgentes = async () => {
      try {
        const result = await get("/visitas/personas/Agente");
        console.log(result);
        setAgentes(result["personas"]);
      } catch (error) {
        console.error(error, "error");
      }
    };
    fetchAgentes();
    const fetchSupervisores = async () => {
      try {
        const result = await get("/visitas/personas/Supervisor");
        console.log(result);
        setSupervisores(result["personas"]);
      } catch (error) {
        console.error(error, "error");
      }
    };
    fetchSupervisores();
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
      nombre: celularAdministracion,
      coordenadas: coordenadas,
      tipo: "URBANIZACION",
      descripcion: direccion,
      direccion: direccion,
      propiedades: cantidadPropiedades,
      supervisorId: selectedSupervisor,
      agentes: selectedAgentes,
    };
    const response = async () => {
      try {
        const result = await post("/visitas/addUbicacion", loadData);
        console.log(result);
      } catch (error) {
        console.log(error);
      }
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

  function handleInputChange(event: any): void {
    setCoordenadas(event.target.value);
  }

  function handleInputClick(event: any): void {
    event.target.select();
  }

  return (
    <div>
      <Button
        onClick={handleOpen}
        className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans py-1 px-4 rounded-lg mt-1"
      >
        Crear Propiedad
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
              Nueva propiedad
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
                {/* <Label className="">
                  <span className="font-sans font-semibold text-[#001554]">
                    Propiedad
                  </span>
                  <Box
                    sx={{
                      minWidth: 500,
                      maxWidth: 360,
                    }}
                  >
                    <select
                      className="mt-1 bg-[#297DE240] rounded-md border-gray-300"
                      style={{ width: "64%" }}
                      value={selectedPropiedad}
                      onChange={(e) => {
                        setSelectedPropiedad(e.target.value);
                        console.log(e.target.value);
                      }}
                    >
                      <option value="">Escoja la propiedad</option>
                      {propiedades.map((propiedad) => (
                        <option key={propiedad.Id} value={propiedad.Id}>
                          {propiedad.Descripcion}
                        </option>
                      ))}
                    </select>
                  </Box>
                </Label> */}
                <Label>
                  <span className="font-sans text-[#001554] font-semibold">
                    Dirección
                  </span>
                  <Input
                    type="search"
                    className="mt-1 bg-[#297DE240] text-[16px]"
                    placeholder="Ingrese una dirección"
                    value={direccion}
                    onChange={(e) => {
                      setDireccion(e.target.value);
                    }}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Celular administración
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese el celular de la administración"
                    value={celularAdministracion}
                    onChange={(e) => {
                      setCelularAdministracion(e.target.value);
                    }}
                  />
                </Label>
                <Label className="mt-4 ">
                  <span className="font-sans text-[#001554] font-semibold">
                    Supervisores
                    <br />
                  </span>
                  <select
                    className="mt-1 bg-[#297DE240] rounded-md border-gray-300"
                    style={{ width: "100%" }}
                    value={selectedSupervisor}
                    onChange={(e) => {
                      setSelectedSupervisor(e.target.value);
                      console.log(e.target.value);
                    }}
                  >
                    <option value="">Escoja el supervisor</option>
                    {supervisores?.map((supervisor) => (
                      <option key={supervisor.id} value={supervisor.id}>
                        {supervisor.nombres}
                      </option>
                    ))}
                  </select>
                </Label>
              </div>
            </main>
            <main className="flex items-center justify-center sm:p-4 md:w-2/2">
              <div className="w-80 font-sans">
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Coordenadas
                  </span>
                  <div className="relative">
                    <Input
                      type="text"
                      className="mt-1 bg-[#297DE240] rounded-2xl text-[16px] pl-10 pr-4"
                      placeholder="Ingrese las coordenadas de la propiedad (lat, long)"
                      value={coordenadas}
                      onChange={handleInputChange}
                      onClick={handleInputClick}
                      pattern="\(-?\d+(\.\d+)?,\s?-?\d+(\.\d+)?\)"
                      title="Please enter the coordinates in the format (lat, long)"
                    />

                    <div
                      className="absolute inset-y-0 right-0 flex items-center px-2"
                      style={{ color: "red" }}
                    >
                      <LocationOnIcon />
                    </div>
                  </div>
                </Label>
                <Label className="">
                  <span className="font-sans text-[#001554] font-semibold">
                    Agentes a cargo
                    <br />
                  </span>
                  <select
                    className="mt-1 bg-[#297DE240] rounded-md border-gray-300"
                    style={{ width: "100%" }}
                    value={selectedAgentes}
                    onChange={(e) => {
                      const selectedOptions = Array.from(
                        e.target.selectedOptions,
                        (option) => option.value
                      );
                      setSelectedAgentes(selectedOptions);
                      console.log(selectedOptions);
                    }}
                  >
                    <option value="">Escoja el agente</option>
                    {agentes?.map((agente) => (
                      <option key={agente.id} value={agente.id}>
                        {agente.nombres}
                      </option>
                    ))}
                  </select>
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Cantidad de propiedades
                  </span>
                  <Input
                    type="number"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese la cantidad de casas"
                    value={cantidadPropiedades}
                    onChange={(e) => {
                      // Parse to number
                      const cantidad = parseInt(e.target.value);
                      setCantidadPropiedades(cantidad);
                    }}
                  />
                </Label>

                {/* <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Placa
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese la placa del visitante"
                    value={placa}
                    onChange={(e) => {
                      setPlaca(e.target.value);
                    }}
                  />
                </Label> */}
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
