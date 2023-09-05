import { SideBarMenuItem } from "types/types";
import { classNames } from "utils/classes";
import Link from "next/link";
import * as Icons from "react-icons/fc";

import React from "react";

interface SideBarMenuItemViewProps {
  item: SideBarMenuItem;
  isOpen: boolean;
}

export function SideBarMenuItemView({
  item,
  isOpen,
}: SideBarMenuItemViewProps) {
  const icon = React.createElement(Icons[item.icon], { size: 30 });
  return (
    <div className="SideBarMenuItemView">
      <Link key={item.id} href={item.url}>
        <div className={classNames("ItemContent", isOpen ? "" : "collapsed")}>
          <div className="icon">{icon}</div>
          <span className="label"> {item.label}</span>
        </div>
      </Link>
      {!isOpen ? <div className="tooltip">{item.label}</div> : ""}
    </div>
  );
}
