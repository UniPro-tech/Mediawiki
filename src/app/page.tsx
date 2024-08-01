import Image from "next/image";
import { Button } from "@/components/button";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "現音令彼(あらねしむか) - らむらによるUTAU音源公式サイト",
  description:
    "『現音令彼』 - らむらによるUTAU音源の公式情報サイト。公式設定、ダウンロードの方法などをお届けします！！",
};

export default function Home() {
  return (
    <main className="flex min-h-screen p-0 m-0 justify-center items-center bg-[#1f1f1f] bg-[url('../images/wipe.png')]">
      <div id="description" className="flex flex-col m-9 p-9 leading-none">
        <h1 className="text-7xl font-bold text-white m-0 font-BIZMincho leading-none">
          <ruby>
            現音令彼<rt>あらねしむか</rt>
          </ruby>
        </h1>
        <Button<"Link"> href="/about">About</Button>
        <Button<"Link"> href="/download">Download</Button>
        <Button<"Link"> href="/license">License</Button>
        <Button<"Link"> href="/contact">Contacts</Button>
      </div>
      <Image
        className="leading-none m-0 p-0"
        src="/images/fullbody.png"
        alt="logo"
        width={500}
        height={0}
      />
    </main>
  );
}
