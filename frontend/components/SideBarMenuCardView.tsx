import { SideBarMenuCard } from "types/types";
import { classNames } from "utils/classes";
import React, { useState, useEffect } from "react";

interface SideBarMenuCardViewProps {
  card: SideBarMenuCard;
  isOpen: boolean;
}

export function SideBarMenuCardView({
  card,
  isOpen,
}: SideBarMenuCardViewProps) {
  return (
    <div className="SideBarMenuCardView">
      <img
        className={classNames("profile", isOpen ? "" : "collapsed")}
        alt={card.displayName}
        src={card.photoUrl}
      />
      <div className={classNames("profileInfo", isOpen ? "" : "collapsed")}>
        <div className="name">{card.displayName}</div>
        <div className="title">{card.title}</div>
        {/* <div className='url'>
            <a href={card.url}>Ir al Perfil</a>
            </div> */}
      </div>
    </div>
  );
}
