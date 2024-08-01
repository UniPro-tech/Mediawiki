import Image from "next/image";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "About - 現音令彼(あらねしむか)",
  description: "現音令彼(あらねしむか)の公式設定についての情報です。使用する前にご一読ください。",
};

export default function Home() {
  return (
    <main className="flex min-h-screen items-center justify-center bg-[#1f1f1f] text-white bg-[url('../images/wipe.png')]">
      <div id="about-desc" className="m-9 p-9">
        <h1 className="text-6xl font-bold">About</h1>
        <ul className="text-1xl leading-6 p-4">
          <li>
            名前:
            <ruby>
              現音令彼<rt>あらねしむか</rt>
            </ruby>
          </li>
          <li>英語表記: AraneShimuka</li>
          <li>性別: 不明</li>
          <li>声別: 女性</li>
          <li>種族: 人外</li>
          <li>年齢: ？(少なくとも人間を超えてる)</li>
          <li>身長: 173.5(変更可)</li>
          <li>誕生日: 7月8日</li>
          <li>持ち物: ドライフラワー</li>
          <li>趣味: 猫吸い</li>
          <li>好きなもの: 猫(特に長毛種)</li>
          <li>苦手なもの: 湿度と花粉(花粉症)</li>
          <li>一人称: 私</li>
          <li>二人称: 君、あなた</li>
          <li>三人称: 君たち、あなた達</li>
        </ul>
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
