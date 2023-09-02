import { useState } from "react";
import { SideBarMenuCard, SideBarMenuItem } from "types/types";
import { classNames } from "utils/classes";
import { VscMenu } from "react-icons/vsc";
import { SideBarMenuCardView } from "./SideBarMenuCardView";
import { SideBarMenuItemView } from "./SideBarMenuItemView";
import { FiLogOut } from "react-icons/fi";
import { useRouter } from "next/router";

interface SideBarMenuProps {
  items: SideBarMenuItem[];
  card: SideBarMenuCard;
}

export function SideBarMenu({ items, card }: SideBarMenuProps) {
  const [isOpen, setIsOpen] = useState<boolean>(true);
  function handleClick() {
    setIsOpen(!isOpen);
  }
  const router = useRouter();

  return (
    <div
      className={classNames("SideBarMenu", isOpen ? "expanded" : "collapsed")}
    >
      <div className="menuButton">
        <button onClick={() => router.push("/")}>
          <FiLogOut />
        </button>
        <button className="hamburgerIcon" onClick={handleClick}>
          <VscMenu />
        </button>
      </div>
      <SideBarMenuCardView key={card.id} card={card} isOpen={isOpen} />
      {items.map((item) => (
        <SideBarMenuItemView key={item.id} item={item} isOpen={isOpen} />
      ))}
    </div>
  );
}
