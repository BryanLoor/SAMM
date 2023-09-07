import * as React from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Modal from "@mui/material/Modal";
import { Input, Label } from "@roketid/windmill-react-ui";
import { get, post } from "utils/services/api";
import { IconButton } from "@mui/material";
import SearchIcon from "@mui/icons-material/Search";
import TextField from "@mui/material/TextField";
import Autocomplete from "@mui/material/Autocomplete";
import CircularProgress from "@mui/material/CircularProgress";

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

export default function ModalVisita({ getAllBitacoras }) {
  const [open, setOpen] = React.useState(false);
  //COMBOBOX for anfitriones
  const [allAnfitriones, setAllAnfitriones] = React.useState([]);
  const [openCBAnfitrion, setOpenCBAnfitrion] = React.useState(false);
  const [isLoadingCBAnfitrion, setIsLoadingCBAnfitrion] = React.useState(false);
  const [idAnfitrionSelected, setIdAnfitrionSelected] = React.useState("");
  const [nameAnfitrionSelected, setNameAnfitrionSelected] = React.useState("");

  //COMBOBOX for ubicacion
  const [allUbicaciones, setAllUbicaciones] = React.useState([]);
  const [openCBUbicacion, setOpenCBUbicacion] = React.useState(false);
  const [isLoadingCBUbicacion, setIsLoadingCBUbicacion] = React.useState(false);
  const [idUbicacionSelected, setIdUbicacionSelected] = React.useState("");
  const [nameUbicacionSelected, setNameUbicacionSelected] = React.useState("");

  const [selectedPropiedad, setSelectedPropiedad] = React.useState(""); //id propiedad
  const [selectedNamePropiedad, setSelectedNamePropiedad] = React.useState("");
  const [ubicaciones, setUbicaciones] = React.useState([]);
  const [idVisitante, setIdVisitante] = React.useState(null);
  const [cedulaVisitante, setCedulaVisitante] = React.useState("");
  const [nombresCompletos, setNombresCompletos] = React.useState("");
  const [apellidosCompletos, setApellidosCompletos] = React.useState("");
  const [nombresCompletosAnfitrion, setNombresCompletosAnfitrion] =
    React.useState("");
  const [apellidosCompletosAnfitrion, setApellidosCompletosAnfitrion] =
    React.useState("");
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

  // React.useEffect(() => {
  //   const fetchData = async () => {
  //     try {
  //       setIsLoadingCBAnfitrion(true);

  //       const result1 = await get("/visitas/getUbicaciones");
  //       const result2 = await get("/visitas/personas");

  //       setPropiedades(result1);
  //       setAllAnfitriones(result2);
  //       console.log(result2);
  //     } catch (err) {
  //       console.error("Error al cargar datos de anfitrion o urbanizaciones");
  //     } finally {
  //       setIsLoadingCBAnfitrion(false);
  //     }
  //   };
  //   fetchData();
  // }, []);

  React.useEffect(() => {
    const getAllUbicaciones = async () => {
      try {
        setIsLoadingCBUbicacion(true);

        const ubicaciones = await get("/visitas/getUbicaciones");

        setAllUbicaciones(ubicaciones);
        console.log(ubicaciones, "************");
      } catch (err) {
        console.error("Error al cargar datos de urbanizaciones");
      } finally {
        setIsLoadingCBUbicacion(false);
      }
    };
    getAllUbicaciones();
  }, []);

  React.useEffect(() => {
    //Clean past anfitriones
    setAllAnfitriones([]);
    setOpenCBAnfitrion(false);
    setIsLoadingCBAnfitrion(false);
    setIdAnfitrionSelected("");
    setNameUbicacionSelected("");

    console.log("aquii");

    if (!idUbicacionSelected) return;

    const getAllAnfitriones = async () => {
      try {
        setIsLoadingCBAnfitrion(true);

        const anfitriones = await get(
          `/visitas/getUsuariosxUbicacion/${idUbicacionSelected}`
        );

        setAllAnfitriones(anfitriones);
        console.log(anfitriones, "aaaaa************");
      } catch (err) {
        console.error("Error al cargar datos de urbanizaciones");
      } finally {
        setIsLoadingCBAnfitrion(false);
      }
    };
    getAllAnfitriones();
  }, [idUbicacionSelected]);

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
      estado: "A",
      idAnfitrion: idAnfitrionSelected,
      idUbicacion: selectedPropiedad,
      ubicacion: selectedNamePropiedad,
      cedula: cedulaVisitante,
      nameVisitante: nombresCompletos,
      lastNameVisitante: apellidosCompletos,
      nameAnfitrion: nombresCompletosAnfitrion,
      lastNameAnfitrion: apellidosCompletosAnfitrion,
      idVisitante: idVisitante,
      phone: phone,
      email: email,
      date: fechaVisita,
      time: horaIngreso,
      duration: tE.hours,
      placa: placa,
    };
    if (
      !idAnfitrionSelected ||
      !selectedPropiedad ||
      !cedulaVisitante ||
      !nombresCompletos ||
      !apellidosCompletos ||
      !phone ||
      !fechaVisita ||
      !horaIngreso ||
      !tiempoEstadia ||
      !email
    ) {
      alert("Complete los campos que son obligatorios");
      return;
    }

    const response = async () => {
      try {
        const result = await post("/visitas/registraVisita", loadData);
        console.log(result);
        cleanVisitaData();
        alert("Visita registrada");
      } catch (error) {
        console.error(error);
        alert("Error en registrar la visita", error);
      }

      await getAllBitacoras();
    };
    try {
      response();
    } catch {
      console.log("No se pudo guardar datos de la visita");
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
        setIdVisitante(result["persona"].Identificacion);
      } catch (error) {
        alert("Persona no encontrada");
        setNombresCompletos("");
        setApellidosCompletos("");
        setIdVisitante(null);
      }
    };
    fetchData();
  }

  //Filtros para buscar el anfitrion por cedula o nombre
  const customFilterOptions = (options, { inputValue }) => {
    // Filtrar las opciones por el valor de búsqueda en las propiedades 'nombre' o 'apellido' o 'cedula'

    return options.filter(
      (opcion) =>
        opcion.Nombres.toLowerCase().includes(inputValue.toLowerCase()) ||
        opcion.Apellidos.toLowerCase().includes(inputValue.toLowerCase()) ||
        opcion.Identificacion.toLowerCase().includes(inputValue.toLowerCase())
    );
  };

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
          <div style={{ width: "90%", margin: "0 auto", paddingTop: "15px" }}>
            {/* Ubicacion */}
            <Autocomplete
              style={{ width: "100%" }}
              placeholder="Escoja una ubicacion"
              id="asynchronous-demo"
              sx={{ width: 300 }}
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
                  label="Ubicaciones"
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
            />
            {/* Anfritrion */}
            <Autocomplete
              value={nameAnfitrionSelected}
              style={{ width: "100%" }}
              placeholder="Escoja un anfitrión"
              id="asynchronous-demo"
              sx={{ width: 300 }}
              open={openCBAnfitrion}
              onOpen={() => {
                setOpenCBAnfitrion(true);
              }}
              onClose={() => {
                setOpenCBAnfitrion(false);
              }}
              filterOptions={customFilterOptions}
              getOptionLabel={(option) => {
                if (!option) {
                  return "";
                } else {
                  return option.Nombres + " " + option.Apellidos;
                }
              }}
              onChange={(event, option) => {
                setIdAnfitrionSelected(option?.Id);
                setNombresCompletosAnfitrion(option?.Nombres);
                setApellidosCompletosAnfitrion(option?.Apellidos);
                setNameAnfitrionSelected("aqui");
              }}
              options={allAnfitriones}
              loading={isLoadingCBAnfitrion}
              renderInput={(params) => (
                <TextField
                  {...params}
                  label="Anfitrión"
                  InputProps={{
                    ...params.InputProps,
                    endAdornment: (
                      <React.Fragment>
                        {isLoadingCBAnfitrion ? (
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
          <div className="flex flex-col overflow-y-auto md:flex-row">
            <main className="flex items-center justify-center sm:p-4 md:w-1/2">
              <div className="w-80">
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
