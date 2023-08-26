import * as React from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Modal from "@mui/material/Modal";
import { Input, Label } from "@roketid/windmill-react-ui";
import { get, post } from "utils/services/api";
import { IconButton } from "@mui/material";
import SearchIcon from "@mui/icons-material/Search";

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

export default function ModalVisita() {
  const [open, setOpen] = React.useState(false);
  const [selectedPropiedad, setSelectedPropiedad] = React.useState("");
  const [propiedades, setPropiedades] = React.useState([] as IPropiedades[]);
  const [cedulaVisitante, setCedulaVisitante] = React.useState("");
  const [nombresCompletos, setNombresCompletos] = React.useState("");
  const [apellidosCompletos, setApellidosCompletos] = React.useState("");
  const [fechaVisita, setFechaVisita] = React.useState("");
  const [horaIngreso, setHoraIngreso] = React.useState("");
  const [tiempoEstadia, setTiempoEstadia] = React.useState("");
  const [placa, setPlaca] = React.useState("");
  const [phone, setPhone] = React.useState("");
  const [email, setEmail] = React.useState("");

  React.useEffect(() => {
    const currentDate = new Date();
    const currentDateString = currentDate.toISOString().slice(0, 10);
    const currentTimeString = currentDate.toLocaleTimeString([], {
      hour: "2-digit",
      minute: "2-digit",
    });

    setFechaVisita(currentDateString);
    setHoraIngreso(currentTimeString);
  }, []);

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
  const cleanVisitaData = () => {
    setSelectedPropiedad("");
    setCedulaVisitante("");
    setNombresCompletos("");
    setApellidosCompletos("");
    setFechaVisita("");
    setHoraIngreso("");
    setTiempoEstadia("");
    setPlaca("");
    setPhone("");
    setEmail("");
  };

  // Btn Guardar
  const handleSave = () => {
    const tE = convertTo12Hour(tiempoEstadia);
    console.log(tiempoEstadia);
    const loadData = {
      estado: "W",
      cedula: cedulaVisitante,
      ubicacion: selectedPropiedad,
      name: nombresCompletos,
      lastName: apellidosCompletos,
      date: fechaVisita,
      time: horaIngreso,
      duration: tE.hours,
      placa: placa,
    };
    const response = async () => {
      try {
        const result = await post("/visitas/registraVisita", loadData);
        console.log(result);
        cleanVisitaData();
      } catch (error) {
        alert("Error en registrar la visita");
      }
    };
    try {
      response();
    } catch {
      console.log("Guardar datos de la visita");
    } finally {
      handleClose();
    }
  };

  function handleSearch(event: any): void {
    const fetchData = async () => {
      try {
        const result = await get(
          `/visitas/buscarPersonaXIden/${cedulaVisitante}`
        );
        console.log(result["persona"]);
        setNombresCompletos(result["persona"].Nombres);
        setApellidosCompletos(result["persona"].Apellidos);
      } catch (error) {
        alert("Persona no encontrada. Necesita crear una nueva");
      }
    };
    fetchData();
  }

  return (
    <div>
      <Button
        onClick={handleOpen}
        className="bg-[#0040AE] hover:bg-[#1B147A] text-white font-sans py-1 px-4 rounded-lg mt-1"
      >
        Crear Visita
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
              Nueva visita
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
                <Label className="">
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
                        <option key={propiedad.id} value={propiedad.id}>
                          {propiedad.direccion}
                        </option>
                      ))}
                    </select>
                  </Box>
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Cédula visitante
                  </span>
                  <div className="flex items-center">
                    <Input
                      type="text"
                      className="mt-1 bg-[#297DE240] text-[16px]"
                      placeholder="Ingrese el número de cédula"
                      value={cedulaVisitante}
                      onChange={(e) => setCedulaVisitante(e.target.value)}
                    />
                    <IconButton onClick={handleSearch} color="primary">
                      <SearchIcon />
                    </IconButton>
                  </div>
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Nombres completos
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese los nombres completos"
                    value={nombresCompletos}
                    onChange={(e) => {
                      setNombresCompletos(e.target.value);
                    }}
                  />
                </Label>
                <Label className="mt-4 ">
                  <span className="font-sans text-[#001554] font-semibold">
                    Apellidos completos
                  </span>
                  <Input
                    typeof="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    type="email"
                    placeholder="Ingrese los apellidos completos"
                    value={apellidosCompletos}
                    onChange={(e) => {
                      setApellidosCompletos(e.target.value);
                    }}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Teléfono
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese la placa del visitante"
                    value={phone}
                    onChange={(e) => {
                      setPhone(e.target.value);
                    }}
                  />
                </Label>
              </div>
            </main>
            <main className="flex items-center justify-center sm:p-4 md:w-2/2">
              <div className="w-80 font-sans">
                <Label className="">
                  <span className="font-sans text-[#001554] font-semibold">
                    Fecha visita
                  </span>
                  <Input
                    type="date"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese la fecha de la visita"
                    value={fechaVisita}
                    onChange={(e) => {
                      setFechaVisita(e.target.value);
                    }}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Hora ingreso
                  </span>
                  <Input
                    type="time"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese la hora de la ingreso "
                    value={horaIngreso}
                    onChange={(e) => {
                      setHoraIngreso(e.target.value);
                    }}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Tiempo estadía
                  </span>
                  <Input
                    type="time"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese un aprox de la estadia "
                    value={tiempoEstadia}
                    onChange={(e) => {
                      setTiempoEstadia(e.target.value);
                    }}
                  />
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Placa (Opcional)
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
                </Label>
                <Label className="mt-4">
                  <span className="font-sans text-[#001554] font-semibold">
                    Correo
                  </span>
                  <Input
                    type="text"
                    className="mt-1 bg-[#297DE240] rounded-2xl text-[16px]"
                    placeholder="Ingrese la placa del visitante"
                    value={email}
                    onChange={(e) => {
                      setEmail(e.target.value);
                    }}
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
