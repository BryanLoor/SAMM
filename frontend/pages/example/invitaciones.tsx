import React, { useState } from "react";
import {
  Calendar,
  momentLocalizer,
  Event,
  EventPropGetter,
} from "react-big-calendar";
import moment from "moment";
import "react-big-calendar/lib/css/react-big-calendar.css";
import Layout from "example/containers/Layout";
import PageTitle from "example/components/Typography/PageTitle";
import Link from "next/link";
import { IconButton, Tooltip } from "@mui/material";
import TableChartIcon from "@mui/icons-material/TableChart";

const localizer = momentLocalizer(moment);

interface Registro extends Event {
  tipo: string;
  total: number;
}

const COLORS = {
  ENTRADAS: "#E07B04",
  SALIDAS: "#0FA60C",
  INVITACIONES: "#5039DF",
  ALERTAS: "#DC1D1D",
  SEGUIMIENTO: "#3C6CFD",
};

const Invitaciones: React.FC = () => {
  const [eventos, setEventos] = useState<Registro[]>([]);

  const handleAgregarRegistro = (dia: Date, tipo: string) => {
    const nuevosEventos: Registro[] = [];
    const fechaActual = moment(dia).startOf("month");
    const ultimoDia = moment(dia).endOf("month");
    while (fechaActual.isSameOrBefore(ultimoDia, "day")) {
      nuevosEventos.push({
        title: "5", // Número total registrado (puede reemplazar "5" por cualquier número)
        start: fechaActual.toDate(),
        end: fechaActual.toDate(),
        tipo: tipo,
        total: 5, // Número total registrado (puede reemplazar "5" por cualquier número)
      });
      fechaActual.add(1, "day");
    }
    setEventos([...eventos, ...nuevosEventos]);
  };

  const eventPropGetter: EventPropGetter<Registro> = (
    event: Registro,
    start: string,
    end: string,
    isSelected: boolean
  ) => {
    return {
      style: {
        backgroundColor: COLORS[event.tipo],
        color: "white",
        backgroundSize: "120%",
      },
      title: `${event.total}`, // Mostrar el número total en el color del evento
    };
  };

  const calendarStyle = {
    border: "none",
  };

  return (
    <Layout>
      <div className="flex flex-row justify-between">
        <PageTitle>Invitaciones</PageTitle>
        <div className="mb-4 flex justify-end mr-2 mt-6">
          <Link href="/example/bitacora-digital">
            <Tooltip title="Bitacora digital">
              <IconButton className="bg-[#0040AE] hover:bg-[#1B147A] text-white">
                <TableChartIcon />
              </IconButton>
            </Tooltip>
          </Link>
        </div>
      </div>
      <hr />
      <div
        className="mt-8"
        style={{
          display: "grid",
          gridTemplateColumns: "auto 1fr",
          gap: "20px",
        }}
      >
        <div className="mt-12">
          <button
            className="bg-[#E07B04] text-white text-center font-semibold font-sans w-60 py-2 rounded-lg"
            onClick={() => handleAgregarRegistro(new Date(), "ENTRADAS")}
          >
            Próximas invitaciones
          </button>
        </div>
        <div>
          <Calendar<Registro>
            localizer={localizer}
            events={eventos}
            startAccessor="start"
            endAccessor="end"
            style={{ height: 500, width: 750, ...calendarStyle }}
            eventPropGetter={eventPropGetter}
            views={["month", "week", "day"]}
          />
        </div>
      </div>
    </Layout>
  );
};

export default Invitaciones;
