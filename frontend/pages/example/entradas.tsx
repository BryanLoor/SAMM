import PageTitle from "example/components/Typography/PageTitle";
import Layout from "example/containers/Layout";
import SectionTitle from "example/components/Typography/SectionTitle";
import { CSSProperties, useEffect, useState } from "react";
import {
  Button,
  Input,
  Label,
  Pagination,
  TableFooter,
  TableHeader,
} from "@roketid/windmill-react-ui";
import Link from "next/link";
import ModalVisita from "./modal-crear-visita";
import React from "react";
import {
  MenuItem,
  Select,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableRow,
} from "@mui/material";
import { get, post, put } from "utils/services/api";
import { IconButton, Tooltip } from "@mui/material";
import CalendarTodayIcon from "@mui/icons-material/CalendarToday";

function Entradas() {
  // btn hora salida
  const [isClicked, setIsClicked] = useState(false);

  const handleClick = () => {
    setIsClicked(!isClicked);
  };

  const buttonStyle = {
    backgroundColor: "#0040AE",
    color: "white",
    padding: "10px 20px",
    border: "none",
    borderRadius: "5px",
    cursor: "pointer",
    width: "6rem",
  };

  // Calendar
  const [counters, setCounters] = useState({
    ENTRADAS: "0",
    SALIDAS: "0",
    INVITACIONES: "0",
    ALERTAS: "0",
    SEGUIMIENTO: "0",
  });
  const [selectedTipo, setSelectedTipo] = useState("ENTRADAS");
  interface InfoCardProps {
    title: string;
    value: string;
    style?: CSSProperties;
    onClick?: () => void;
    name?: string;
  }

  useEffect(() => {
    const fetchData = async () => {
      const result = await get("/visitas/getCountTipo");
      setCounters(result);
    };
    fetchData();
    updateTable(selectedTipo);
  }, [selectedTipo]);
  const InfoCard: React.FC<InfoCardProps> = ({
    title,
    value,
    style,
    onClick,
  }) => {
    return (
      <div style={style} onClick={onClick}>
        <h3>{title}</h3>
        <p>{value}</p>
      </div>
    );
  };

  interface ITableDataEvents {
    celular: string;
    id: number;
    nombre: string;
    apellido: string;
    identificacion: string;
    propiedad: string;
    hora_ingreso: string;
    hora_salida: string;
    hora_estimada: string;
    duracion: string;
    observaciones: string;
    invitacionCreada: boolean;
    placa: string;
    estado: string;
  }
  interface CardInfo {
    title: string;
    value: string;
    style: CSSProperties;
    name?: string;
  }

  const cards: CardInfo[] = [
    {
      title: "Entradas",
      name: "ENTRADAS",
      value: counters.ENTRADAS,
      style: {
        backgroundColor: "#E07B04",
        fontFamily: "sans-serif",
        color: "white",
        width: "12rem",
        height: "6rem",
        borderRadius: "8px",
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        cursor: "pointer",
        boxShadow: "0 2px 4px 0 gray",
        fontWeight: 500,
      },
    },
    {
      title: "Salidas",
      name: "SALIDAS",
      value: counters.SALIDAS,
      style: {
        backgroundColor: "#0FA60C",
        fontFamily: "sans-serif",
        color: "white",
        width: "12rem",
        height: "6rem",
        borderRadius: "8px",
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        cursor: "pointer",
        boxShadow: "0 2px 4px 0 gray",
        fontWeight: 500,
      },
    },
    {
      title: "Invitaciones sin QR",
      name: "INVITACIONES",
      value: counters.INVITACIONES,
      style: {
        backgroundColor: "#5039DF",
        fontFamily: "sans-serif",
        color: "white",
        width: "12rem",
        height: "6rem",
        borderRadius: "8px",
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        cursor: "pointer",
        boxShadow: "0 2px 4px 0 gray",
        fontWeight: 500,
      },
    },
    {
      title: "Alertas de seguridad",
      name: "ALERTAS",
      value: counters.ALERTAS,
      style: {
        backgroundColor: "#DC1D1D",
        fontFamily: "sans-serif",
        color: "white",
        width: "12rem",
        height: "6rem",
        borderRadius: "8px",
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        cursor: "pointer",
        boxShadow: "0 2px 4px 0 gray",
        fontWeight: 500,
      },
    },
    {
      title: "Seguimiento invitaciones",
      name: "SEGUIMIENTO",
      value: counters.SEGUIMIENTO,
      style: {
        backgroundColor: "#3C6CFD",
        fontFamily: "sans-serif",
        color: "white",
        width: "12rem",
        height: "6rem",
        borderRadius: "8px",
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        cursor: "pointer",
        boxShadow: "0 2px 4px 0 gray",
        fontWeight: 500,
      },
    },
  ];

  function getEstado(status: string) {
    switch (status) {
      case "A":
        return "activa";
      case "W":
        return "activa";
      case "F":
        return "completada";
      case "I":
        return "inválida";
      case "S":
        return "sin_salida";
      case "N":
        return "nunca_realizada";
      case "R":
        return "atrasada";
      default:
        return "";
    }
  }
  function getCodigoEstado(status: string) {
    switch (status) {
      case "activa":
        return "A";
      case "completada":
        return "F";
      case "inválida":
        return "I";
      case "sin_salida":
        return "S";
      case "nunca_realizada":
        return "N";
      case "atrasada":
        return "R";
      default:
        return "";
    }
  }

  function handleChangeStatus(id: number, status: string) {
    const estadoE = getCodigoEstado(status);
    console.log(estadoE, status);
    const SetCStatus = async () => {
      const result = await post("/visitas/actualizar/" + id, {
        Estado: estadoE,
      });
      console.log(result);
    };
    SetCStatus();
    setStatus(status);
    window.location.reload();
  }

  function handleCloseVisit(id: number) {
    const SetSalida = async () => {
      const result = await get("/visitas/cerrarVisita/" + id);
      console.log(result);
      setFechaSalida(result.FechaSalida);
    };
    SetSalida();
    window.location.reload();
  }

  // Modal de crear visita

  const [openModal, setOpenModal] = React.useState(false);

  const handleOpenModal = () => {
    setOpenModal(true);
  };

  const updateTable = (tipo: string) => {
    const fetchData = async () => {
      try {
        const result = await post("/visitas/viewList", { tipo: tipo });
        console.log({ tipo: tipo }, result, "88888/////");
        setTableData(result);
      } catch (err) {
        console.error(err, "error");
      }
    };
    fetchData();
  };

  const [tableData, setTableData] = useState<ITableDataEvents[]>([]);
  const [fechaSalida, setFechaSalida] = useState(null);

  // paginacion min 10 users por pagina
  const [currentPage, setCurrentPage] = useState(1);

  const itemsPerPage = 10;
  const totalPages = Math.ceil(tableData.length / itemsPerPage);

  const onPageChange = (page: number) => {
    setCurrentPage(page);
  };

  // Select Status
  const [status, setStatus] = React.useState("");

  // Select Alerta
  const [alerta, setAlerta] = React.useState("");

  // Search input
  const [searchInput, setSearchInput] = useState("");
  const [filteredTableData, setFilteredTableData] = useState<
    ITableDataEvents[]
  >([]);

  const handleSearch = (event: React.ChangeEvent<HTMLInputElement>) => {
    const input = event.target.value;
    setSearchInput(input);

    const filteredData = tableData.filter((event) => {
      const fullName = `${event.nombre} ${event.apellido}`;
      return fullName.toLowerCase().includes(input.toLowerCase());
    });

    setFilteredTableData(filteredData);
    setCurrentPage(1); // Reiniciar la página actual a la primera página después de realizar la búsqueda
  };

  useEffect(() => {
    // Actualizar los datos filtrados cuando cambien los datos originales o el valor de búsqueda
    const filteredData = tableData.filter((event) => {
      const fullName = `${event.nombre} ${event.apellido}`;
      return fullName.toLowerCase().includes(searchInput.toLowerCase());
    });

    setFilteredTableData(filteredData);
  }, [tableData, searchInput]);

  const startIndex = (currentPage - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;

  const paginatedTableData = filteredTableData.slice(startIndex, endIndex);

  return (
    <Layout>
      <div className="flex flex-row justify-between">
        <div>
          <PageTitle>Registro visitas</PageTitle>
        </div>

        <div className="mb-4 flex justify-end mr-2 mt-6">
          <Link href="/example/registro-visitas" className="mr-2">
            <Tooltip title="Proximas invitaciones">
              <IconButton className="bg-[#0040AE] hover:bg-[#1B147A] text-white">
                <CalendarTodayIcon />
              </IconButton>
            </Tooltip>
          </Link>

          <ModalVisita />
        </div>
      </div>
      <div className="flex flex-row justify-between mb-6">
        <div>
          <Select
            value={selectedTipo}
            onChange={(event) => setSelectedTipo(event.target.value)}
            className="h-9 text-[#001554] font-sans font-semibold"
          >
            <MenuItem className="text-[#001554]" value="RECIENTES">
              Visitas recientes
            </MenuItem>
            <MenuItem className="text-[#001554]" value="ATRASADAS">
              Visitas atrasadas
            </MenuItem>
            <MenuItem className="text-[#001554]" value="NEGADAS">
              Visitas negadas
            </MenuItem>
            <MenuItem className="text-[#001554]" value="SEGUIMIENTO">
              Visitas con seguimiento
            </MenuItem>
            <MenuItem className="text-[#001554]" value="ALERTAS">
              Visitas con alerta de seguridad
            </MenuItem>
            <MenuItem className="text-[#001554]" value="SIN_CODIGO">
              Visitas sin código de seguridad
            </MenuItem>
            <MenuItem className="text-[#001554]" value="ENTRADAS">
              Solo entradas
            </MenuItem>
            <MenuItem className="text-[#001554]" value="SALIDAS">
              Solo salidas
            </MenuItem>
            <MenuItem className="text-[#001554]" value="PROXIMAS">
              Próximas visitas
            </MenuItem>
            <MenuItem className="text-[#001554]" value="TODAS">
              Todas
            </MenuItem>
          </Select>
        </div>
        <div className="flex items-center w-44">
          <Input
            value={searchInput}
            onChange={handleSearch}
            placeholder="Ingrese un nombre"
          />
        </div>
      </div>

      <div className="grid gap-4 mb-8 md:grid-cols-2 xl:grid-cols-5">
        {cards.map((card, index) => (
          <InfoCard
            key={index}
            title={card.title}
            value={card.value}
            style={card.style}
            onClick={() => {
              console.log(card.name);
              setSelectedTipo(card.name);
            }}
          />
        ))}
      </div>

      <hr className="mb-6" />

      <SectionTitle>
        <p className="text-[#001554]">
          {selectedTipo === "" && "Entradas"} {/* Título predeterminado */}
          {selectedTipo === "RECIENTES" && "Visitas recientes"}
          {selectedTipo === "ATRASADAS" && "Visitas atrasadas"}
          {selectedTipo === "NEGADAS" && "Visitas negadas"}
          {selectedTipo === "SEGUIMIENTO" && "Visitas con seguimiento"}
          {selectedTipo === "ALERTAS" && "Visitas con alerta de seguridad"}
          {selectedTipo === "SIN_CODIGO" && "Visitas sin código de seguridad"}
          {selectedTipo === "ENTRADAS" && "Entradas"}
          {selectedTipo === "SALIDAS" && "Salidas"}
          {selectedTipo === "PROXIMAS" && "Próximas visitas"}
        </p>
      </SectionTitle>

      <TableContainer className="mb-8">
        <Table>
          <TableHeader>
            <tr className=" text-[#0040AE]">
              <TableCell></TableCell>
              <TableCell>#</TableCell>
              <TableCell className="text-center">Status visita</TableCell>
              <TableCell>Nombres</TableCell>
              <TableCell>Apellidos</TableCell>
              <TableCell>Identificacion</TableCell>
              <TableCell className="text-center">
                Antecedentes penales
              </TableCell>
              <TableCell>Celular</TableCell>
              <TableCell className="text-center">Propiedad ingreso</TableCell>
              <TableCell className="text-center">Hora ingreso</TableCell>
              <TableCell className="text-center">Hora salida</TableCell>
              <TableCell className="text-center">Hora estimada</TableCell>
              <TableCell>Placa</TableCell>
              <TableCell>Observaciones</TableCell>
              <TableCell className="text-center">Alertas</TableCell>
              <TableCell className="text-center">Invitacion creada</TableCell>
            </tr>
          </TableHeader>
          <TableBody>
            {paginatedTableData.map((event, index) => (
              <TableRow className="text-[#001554]" key={index}>
                <TableCell>
                  <div className="flex items-center text-sm">
                    <Label check>
                      <Input
                        type="checkbox"
                        className="text-green-500 transform scale-110"
                      />
                    </Label>
                  </div>
                </TableCell>
                <TableCell>
                  <span className="text-sm">{event.id}</span>
                </TableCell>
                <TableCell>
                  <Select
                    value={getEstado(event.estado)}
                    onChange={(er) => {
                      handleChangeStatus(event.id, er.target.value);
                    }}
                    className="h-8 text-sm"
                  >
                    <MenuItem value="">
                      <b>
                        Seleccionar Estado
                        <hr />
                      </b>
                    </MenuItem>
                    <MenuItem value="activa">Activa</MenuItem>
                    <MenuItem value="atrasada">Atrasada</MenuItem>
                    <MenuItem value="completada">Completada</MenuItem>
                    <MenuItem value="inválida">Inválida</MenuItem>
                    <MenuItem value="sin_salida">Sin salida</MenuItem>
                    <MenuItem value="nunca_realizada">Nunca realizada</MenuItem>
                  </Select>
                </TableCell>
                <TableCell>
                  <span className="text-sm">{event.nombre}</span>
                </TableCell>
                <TableCell>
                  <span className="text-sm">{event.apellido}</span>
                </TableCell>
                <TableCell>
                  <span className="text-sm">{event.identificacion}</span>
                </TableCell>
                <TableCell>
                  <div className="flex justify-center text-sm">
                    <Label check>
                      <Input
                        type="checkbox"
                        className="text-blue-700 transform scale-110"
                      />
                    </Label>
                  </div>
                </TableCell>
                <TableCell>
                  <span className="text-sm">{event.celular}</span>
                </TableCell>
                <TableCell>
                  <span className="text-sm">Casa 16A</span>
                </TableCell>
                <TableCell>
                  <span className="text-sm">{event.hora_ingreso}</span>
                </TableCell>
                <TableCell>
                  <div className="flex justify-center text-sm">
                    <Label>
                      {!event.hora_salida && (
                        <button
                          className="font-sans font-normal"
                          style={buttonStyle}
                          onClick={() => {
                            handleClick();
                            handleCloseVisit(event.id);
                          }}
                        >
                          Confirmar
                        </button>
                      )}
                      {event.hora_salida && <span>{event.hora_salida}</span>}
                    </Label>
                  </div>
                </TableCell>
                <TableCell>
                  <span className="text-sm">{event.hora_estimada}</span>
                </TableCell>
                <TableCell>
                  <span className="text-sm">{event.placa}</span>
                </TableCell>
                <TableCell>
                  <span className="text-sm">{event.observaciones}</span>
                </TableCell>
                <TableCell>
                  <Select
                    value={event.alerta}
                    onChange={(event) => setAlerta(event.target.value)}
                    className="h-8 text-sm"
                  >
                    <MenuItem value="">
                      <b>
                        Seleccionar ss
                        <hr />
                      </b>
                    </MenuItem>
                    <MenuItem value="seguridad">Alertas de seguridad</MenuItem>
                    <MenuItem value="invitaciones">
                      Invitaciones con seguimiento
                    </MenuItem>
                  </Select>
                </TableCell>
                <TableCell>
                  <span className="text-sm">
                    {event.invitacionCreada ? "Web" : "Codigo QR (APP)"}
                  </span>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
      <TableFooter className="mb-10">
        <Pagination
          totalResults={filteredTableData.length}
          resultsPerPage={itemsPerPage}
          onChange={onPageChange}
          label={`${startIndex + 1}-${endIndex} of ${filteredTableData.length}`}
        />
      </TableFooter>
    </Layout>
  );
}

export default Entradas;
