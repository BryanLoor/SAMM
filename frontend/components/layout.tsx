"use client";

import { SideBarMenu } from "components/SideBarMenu";
import React, { useState, useEffect, ReactNode } from "react";
import { SideBarMenuCard, SideBarMenuItem } from "types/types";
import {
  FcAdvertising,
  FcHome,
  FcWorkflow,
  FcSurvey,
  FcManager,
} from "react-icons/fc";

interface LayoutProps {
  children: ReactNode;
}
function Layout({ children }: LayoutProps) {
  const [items, setItems] = useState<SideBarMenuItem[]>([]);
  const [card, setCard] = useState<SideBarMenuCard>({
    id: "card001",
    displayName: "Marcos Rivas",
    title: "Youtuber",
    photoUrl: "/assets/img/Steve.jpg",
    url: "/",
  });

  useEffect(() => {
    const menuT = localStorage.getItem("menu");

    if (menuT) {
      const menuJson = JSON.parse(menuT);
      const transformedItems: SideBarMenuItem[] = menuJson.map((item: any) => ({
        id: item.Id,
        label: item.Descripcion,
        icon: item.Icon,
        // icon: item.Icon ? item.Icon : FcAdvertising,
        url: "/" + item.path,
      }));
      setItems(transformedItems);
      console.log(transformedItems);
    }

    const user = localStorage.getItem("userAuth");

    if (user) {
      const userJson = JSON.parse(user);
      setCard((prevCard) => ({
        ...prevCard,
        displayName: userJson.Nombres + " " + userJson.Apellidos, // Cambia a la propiedad correcta en tu objeto userAuth
        title: userJson.Descripcion, // Cambia a la propiedad correcta en tu objeto userAuth
        // photoUrl: userJson.photoUrl, // Si también quieres actualizar la foto
      }));
    }

    // }
  }, []);
  return (
    <div className="layout">
      <SideBarMenu key={card.id} items={items} card={card} />
      <main className="layout__main-content">{children}</main>
    </div>
  );
}

export default Layout;
