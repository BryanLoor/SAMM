import PageTitle from "example/components/Typography/PageTitle";
import Layout from "example/containers/Layout";
import SectionTitle from "example/components/Typography/SectionTitle";
import { CSSProperties, useState } from "react";
import { Input, Label, TableHeader } from "@roketid/windmill-react-ui";
import ModalVisita from "../visitas/modal-crear-visita";
import React from "react";
import {
  IconButton,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableRow,
} from "@mui/material";
import Link from "next/link";
import CalendarTodayIcon from "@mui/icons-material/CalendarToday";

function Entradas() {
  // Btn hora salida
  const [isClicked, setIsClicked] = useState(false);

  const handleClick = () => {
    setIsClicked(!isClicked);
  };

  const buttonStyle = {
    backgroundColor: isClicked ? "green" : "#0040AE",
    color: "white",
    padding: "10px 20px",
    border: "none",
    borderRadius: "5px",
    cursor: "pointer",
    width: "6rem",
  };

  interface InfoCardProps {
    title: string;
    value: string;
    style?: CSSProperties;
  }

  const InfoCard: React.FC<InfoCardProps> = ({ title, value, style }) => {
    return (
      <div style={style}>
        <h3>{title}</h3>
        <p className="font-bold">{value}</p>
      </div>
    );
  };

  interface CardInfo {
    title: string;
    value: string;
    style: CSSProperties;
  }

  const cards: CardInfo[] = [
    {
      title: "Invitaciones sin QR",
      value: "3",
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
      title: "Invitaciones creadas",
      value: "4",
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
      title: "Alertas de seguridad",
      value: "3",
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
      title: "Seguimiento invitaciones",
      value: "5",
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

  const [openModal, setOpenModal] = React.useState(false);

  const handleOpenModal = () => {
    setOpenModal(true);
  };

  return (
    <Layout>
      <div className="flex flex-row justify-between">
        <PageTitle>
          <p className="text-[#001554] font-sans">Bitácora Digital</p>
        </PageTitle>
        <div className="mb-4 flex justify-end mr-2 mt-6">
          <Link href="/example/invitaciones" className="mr-2">
            <IconButton className="bg-[#0040AE] hover:bg-[#1B147A] text-white">
              <CalendarTodayIcon />
            </IconButton>
          </Link>

          <ModalVisita />
        </div>
      </div>

      <div className="grid gap-4 mb-8 md:grid-cols-2 xl:grid-cols-5">
        {cards.map((card, index) => (
          <InfoCard
            key={index}
            title={card.title}
            value={card.value}
            style={card.style}
          />
        ))}
      </div>

      <hr className="mb-6" />

      <SectionTitle>
        <p className="text-[#001554] font-sans">Registro</p>
      </SectionTitle>

      <TableContainer className="mb-8">
        <Table>
          <TableHeader>
            <tr className=" text-[#0040AE]">
              <TableCell></TableCell>
              <TableCell>#</TableCell>
              <TableCell>Nombres</TableCell>
              <TableCell>Apellidos</TableCell>
              <TableCell>Identificacion</TableCell>
              <TableCell>Celular</TableCell>
              <TableCell className="text-center">Propiedad ingreso</TableCell>
              <TableCell className="text-center">Hora ingreso</TableCell>
              <TableCell className="text-center">Hora salida</TableCell>
              <TableCell>Placa</TableCell>
              <TableCell>Observaciones</TableCell>
              <TableCell>Alertas</TableCell>
              <TableCell className="text-center">Invitacion creada</TableCell>
            </tr>
          </TableHeader>
          <TableBody>
            <TableRow className="text-[#001554]">
              <TableCell>
                <div className="flex items-center text-sm">
                  <Label check>
                    <Input type="checkbox" className="text-lg" />
                  </Label>
                </div>
              </TableCell>
              <TableCell>
                <span className="text-sm">1</span>
              </TableCell>
              <TableCell>
                <span className="text-sm">Fernando Alfredo</span>
              </TableCell>
              <TableCell>
                <span className="text-sm">Torres Valencia</span>
              </TableCell>
              <TableCell>
                <span className="text-sm">1729038476</span>
              </TableCell>
              <TableCell>
                <span className="text-sm">0998752293</span>
              </TableCell>
              <TableCell>
                <span className="text-sm">Casa 16A</span>
              </TableCell>
              <TableCell>
                <span className="text-sm">10:00am</span>
              </TableCell>
              <TableCell>
                <div className="flex justify-center text-sm">
                  <Label>
                    <button
                      className="font-sans font-normal"
                      style={buttonStyle}
                      onClick={handleClick}
                    >
                      {isClicked ? "Listo!" : "Confirmar"}
                    </button>
                  </Label>
                </div>
              </TableCell>
              <TableCell>
                <span className="text-sm">*******</span>
              </TableCell>
              <TableCell>
                <span className="text-sm">*******</span>
              </TableCell>
              <TableCell>
                <span className="text-sm">""</span>
              </TableCell>
              <TableCell>
                <span className="text-sm">Codigo QR (APP)</span>
              </TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </TableContainer>
    </Layout>
  );
}

export default Entradas;
