import React, { useState } from "react";
import {
  Calendar,
  momentLocalizer,
  Event,
  EventPropGetter,
} from "react-big-calendar";
import moment from "moment";
import "react-big-calendar/lib/css/react-big-calendar.css";
import Layout from "components/layout";
import PageTitle from "example/components/Typography/PageTitle";
import Link from "next/link";
import { get, post } from "utils/services/api";
import { IconButton, Tooltip } from "@mui/material";
import TableChartIcon from "@mui/icons-material/TableChart";
import ModalVisita from "../visitas/modal-crear-visita";
import { useRouter } from "next/navigation";
const localizer = momentLocalizer(moment);

interface Registro extends Event {
  tipo: string;
  total: number;
  //add two fields optional inicio_visita, salida_visita
  inicio_visita?: Date;
  salida_visita?: Date;
  salida_estimada?: Date;
}

const COLORS = {
  ENTRADAS: "#E07B04",
  SALIDAS: "#0FA60C",
  INVITACIONES: "#5039DF",
  ALERTAS: "#DC1D1D",
  SEGUIMIENTO: "#3C6CFD",
};

const Calendario: React.FC = () => {
  const router = useRouter();
  const [eventos, setEventos] = useState<Registro[]>([]);
  const [eventosDiarios, setEventosDiarios] = useState<Registro[]>([]);
  const [selectedView, setSelectedView] = useState("month");

  const handleAgregarRegistro = (dia: Date, tipo: string) => {
    setEventos([]);
    const eventosDelDia = async () => {
      console.log(dia);
      console.log(
        moment(dia)
          .startOf(selectedView as moment.unitOfTime.StartOf)
          .toDate()
      );
      console.log(
        moment(dia)
          .endOf(selectedView as moment.unitOfTime.StartOf)
          .toDate()
      );
      try {
        const eventos = await post("/visitas/viewCalendar", {
          tipo: tipo,
          view: selectedView,
        });
        console.log(eventos);
        const nuevosEventos: Registro[] = [];

        Object.keys(eventos).forEach((key) => {
          const evento = eventos[key];
          console.log(evento);
          nuevosEventos.push({
            title: evento.length,
            start: evento[0].inicio_visita,
            end:
              evento[0].salida_visita ||
              evento[0].salida_estimada ||
              evento[0].inicio_visita,
            tipo: tipo,
            total: evento.length,
          });
        });
        setEventos([...nuevosEventos]);

        /*for(let i = 0; i < eventos.length; i++) {
          console.log(eventos[i]);
          nuevosEventos.push({
            title: tipo,
            start: eventos[i].inicio_visita,
            end: eventos[i].salida_visita || eventos[i].salida_estimada || eventos[i].inicio_visita,
            tipo: tipo,
            total: 1,
          });
        }*/
      } catch (error) {
        // Handle any errors that occur during the async operation
        console.error("Error retrieving eventos:", error);
        throw error; // Rethrow the error to propagate it further if needed
      }
    };
    eventosDelDia();
    // Call the function and handle the resolved value
    /*
      .then((listEventos) => {
        console.log(listEventos);
        setEventosDiarios(listEventos);
      })
      .catch((error) => {
        // Handle any errors that occurred during the async operation
        console.error("Error:", error);
      });*/

    /*const fechaActual = moment(dia).startOf("month");
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
    */
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
        <PageTitle>Registro de Visitas</PageTitle>
        <div className="mb-4 flex justify-end mr-2 mt-6">
          <Link href="/example/entradas" className="mr-2">
            <Tooltip title="Ver como Tabla">
              <IconButton className="bg-[#0040AE] hover:bg-[#1B147A] text-white">
                <TableChartIcon />
              </IconButton>
            </Tooltip>
          </Link>
          <ModalVisita />
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
            className="bg-[#E07B04] text-white text-center font-semibold font-sans w-full py-2 rounded-lg"
            onClick={() => handleAgregarRegistro(new Date(), "ENTRADAS")}
          >
            Entradas
          </button>

          <button
            className="bg-[#0FA60C] text-white text-center font-semibold font-sans w-full py-2 mt-2 rounded-lg"
            onClick={() => handleAgregarRegistro(new Date(), "SALIDAS")}
          >
            Salidas
          </button>
          <button
            className="bg-[#5039DF] text-white text-center font-semibold font-sans w-full py-2 mt-2 rounded-lg"
            onClick={() => handleAgregarRegistro(new Date(), "INVITACIONES")}
          >
            Invitaciones sin QR
          </button>
          <button
            className="bg-[#DC1D1D] text-white text-center font-semibold font-sans w-full py-2 mt-2 rounded-lg"
            onClick={() => handleAgregarRegistro(new Date(), "ALERTAS")}
          >
            Alertas de seguridad
          </button>
          <button
            className="bg-[#3C6CFD] text-white text-center font-semibold font-sans w-full py-2 mt-2 rounded-lg"
            onClick={() => handleAgregarRegistro(new Date(), "SEGUIMIENTO")}
          >
            Seguimiento invitaciones
          </button>
        </div>
        <div>
          <Calendar
            localizer={localizer}
            events={eventos}
            startAccessor="start"
            endAccessor="end"
            style={{ height: 500, width: 750, ...calendarStyle }}
            eventPropGetter={eventPropGetter}
            views={["month"]}
            onView={(view) => setSelectedView(view)}
            onSelectEvent={(event) => {
              router.push("visitas/entradas");
            }}
          />
        </div>
      </div>
    </Layout>
  );
};

export default Calendario;
