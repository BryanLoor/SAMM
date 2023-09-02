import * as React from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Typography from "@mui/material/Typography";
import Modal from "@mui/material/Modal";
import { Input, Label } from "@roketid/windmill-react-ui";
import { get, post, put } from "utils/services/api";
import { IconButton } from "@mui/material";
import SearchIcon from "@mui/icons-material/Search";
import TextField from "@mui/material/TextField";
import Autocomplete from "@mui/material/Autocomplete";
import CircularProgress from "@mui/material/CircularProgress";
import { Textarea } from "@roketid/windmill-react-ui";

const style = {
  position: "absolute",
  top: "50%",
  left: "50%",
  transform: "translate(-50%, -50%)",
  width: "90%",
  height: "90%",
  bgcolor: "background.paper",
  border: "2px solid #000",
  boxShadow: 24,
  p: 4,
};

export default function ModalEditarVisita({
  visita,
  detectVistaStatus,
  getAllBitacoras,
}) {
  const STATUS = [
    {
      code: "A",
      description: "Activo",
    },
    {
      code: "C",
      description: "Completada",
    },
    {
      code: "I",
      description: "Inválida",
    },
  ];

  const ANTECEDENTES = [
    {
      code: "Si",
      description: true,
    },
    {
      code: "No",
      description: false,
    },
  ];

  const [open, setOpen] = React.useState(false);
  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);

  const [allAnfitriones, setAllAnfitriones] = React.useState([]);
  const [openCBAnfitrion, setOpenCBAnfitrion] = React.useState(false);
  const [isLoadingCBAnfitrion, setIsLoadingCBAnfitrion] = React.useState(false);
  const [idAnfitrionSelected, setIdAnfitrionSelected] = React.useState("");

  const [selectedPropiedad, setSelectedPropiedad] = React.useState(""); //id propiedad
  const [selectedNamePropiedad, setSelectedNamePropiedad] = React.useState("");
  const [propiedades, setPropiedades] = React.useState([] as IPropiedades[]);
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

  const [statusUser, setStatusUser] = React.useState("");
  const [hasAntecendtes, setHasAntecendtes] = React.useState(false);
  const [hasAntecendtesValue, setHasAntecendtesValue] = React.useState("No");

  const [idBitacoraVisita, setIdBitacoraVisita] = React.useState("");

  const [observaciones, setObservaciones] = React.useState("");
  //0925691503
  //Cargar los datos inicializados
  React.useEffect(() => {
    const {
      Id,
      Estado,
      NombresVisitante,
      ApellidosVisitante,
      Codigo,
      NombresAnfitrion,
      ApellidosAnfitrion,
      IdAnfitrion,
      Telefono,
      FechaVisita,
      Antecedentes,
      IdVisita,
      Placa,
      Correo,
      IdUbicacion,
      Ubicacion,
      Observaciones,
    } = visita;

    setIdBitacoraVisita(Id);

    setNombresCompletos(NombresVisitante);
    setApellidosCompletos(ApellidosVisitante);
    setNombresCompletosAnfitrion(NombresAnfitrion);
    setApellidosCompletosAnfitrion(ApellidosAnfitrion);
    setIdAnfitrionSelected(IdAnfitrion);

    setIdVisitante(IdVisita);
    setCedulaVisitante(Codigo);
    setPhone(Telefono);
    setPlaca(Placa);
    setEmail(Correo);

    setSelectedPropiedad(IdUbicacion);
    setSelectedNamePropiedad(Ubicacion);

    setStatusUser(Estado);
    setHasAntecendtes(Antecedentes);
    setHasAntecendtesValue(Antecedentes ? "Si" : "No");
    setObservaciones(Observaciones);
  }, []);

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

  React.useEffect(() => {
    const fetchData = async () => {
      try {
        setIsLoadingCBAnfitrion(true);

        const result1 = await get("/visitas/getUrbanizaciones");
        const result2 = await get("/visitas/personas");

        setPropiedades(result1);
        setAllAnfitriones(result2);
        console.log(result2);
      } catch (err) {
        console.error("Error al cargar datos de anfitrion o urbanizaciones");
      } finally {
        setIsLoadingCBAnfitrion(false);
      }
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
  const handleEdit = () => {
    const tE = convertTo12Hour(tiempoEstadia);
    console.log(tiempoEstadia);
    const loadData = {
      estado: statusUser,
      antecedentes: hasAntecendtes,
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
      placa: placa,
      observaciones: observaciones,
    };

    console.log(loadData, "***********");

    const response = async () => {
      try {
        const result = await put(
          `/visitas/updateVisita/${idBitacoraVisita}`,
          loadData
        );
        console.log(result);
        // cleanVisitaData();
        alert("Visita actualizada");
        await getAllBitacoras();
      } catch (error) {
        console.error(error);
        alert("Error en actualizar la visita", error);
      }
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
      <Button onClick={handleOpen}>Editar</Button>
      <Modal
        open={open}
        onClose={handleClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <Box sx={style}>
          <Typography
            id="modal-modal-title"
            variant="h6"
            component="h2"
            style={{ marginBottom: "20px" }}
          >
            Editar visita
          </Typography>
          <div>
            <Autocomplete
              value={{
                Id: idAnfitrionSelected,
                Nombres: nombresCompletosAnfitrion,
                Apellidos: apellidosCompletosAnfitrion,
              }}
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
              getOptionLabel={(option) =>
                option.Nombres + " " + option.Apellidos
              }
              onChange={(event, option) => {
                setIdAnfitrionSelected(option.Id);
                setNombresCompletosAnfitrion(option.Nombres);
                setApellidosCompletosAnfitrion(option.Apellidos);
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
                        const selectedId = parseInt(e.target.value); // Convertir el valor a número si es necesario
                        const selectedPropiedad = propiedades.find(
                          (propiedad) => propiedad.id === selectedId
                        );
                        setSelectedNamePropiedad(selectedPropiedad.nombre);
                        setSelectedPropiedad(selectedId);
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
                {/* <Label className="">
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
                </Label> */}
                <Label className="">
                  <span className="font-sans font-semibold text-[#001554]">
                    Status
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
                      value={statusUser}
                      onChange={(e) => {
                        const selectedId = e.target.value; // Convertir el valor a número si es necesario
                        console.log(selectedId, "selected");
                        const selectedStatus = STATUS.find(
                          (status) => status.code === selectedId
                        );
                        setStatusUser(selectedStatus.code);
                        // setSelectedPropiedad(selectedId);
                      }}
                    >
                      <option value="">Escoja el status</option>
                      {STATUS.map((status) => (
                        <option key={status.code} value={status.code}>
                          {status.description}
                        </option>
                      ))}
                    </select>
                  </Box>
                </Label>
                <Label>
                  <span>Observaciones</span>
                  <Textarea
                    value={observaciones}
                    className="mt-1"
                    rows="3"
                    placeholder="Observaciones"
                    onChange={(e) => setObservaciones(e.target.value)}
                  />
                </Label>
                <Label className="">
                  <span className="font-sans font-semibold text-[#001554]">
                    Antecedentes penales
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
                      value={hasAntecendtesValue}
                      onChange={(e) => {
                        const selectedId = e.target.value; // Convertir el valor a número si es necesario
                        console.log(selectedId, "selected");
                        const selectedStatus = ANTECEDENTES.find(
                          (status) => status.code === selectedId
                        );
                        setHasAntecendtesValue(selectedStatus.code);
                        setHasAntecendtes(selectedStatus?.description);
                      }}
                    >
                      <option value="">Antecedentes penales</option>
                      {ANTECEDENTES.map((status) => (
                        <option key={status.code} value={status.code}>
                          {status.code}
                        </option>
                      ))}
                    </select>
                  </Box>
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
