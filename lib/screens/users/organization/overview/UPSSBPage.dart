import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/components/bulletList2.dart';
import 'package:sandiwapp/components/imageBuffer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UPSSBPage extends StatefulWidget {
  const UPSSBPage({super.key});

  @override
  State<UPSSBPage> createState() => _UPSSBPageState();
}

class _UPSSBPageState extends State<UPSSBPage> {
  int activeIndex = 0;
  final urlImages = [
    'https://i.imgur.com/EIrZ11v.jpg',
    'https://i.imgur.com/SaZLZiM.jpg',
    'https://i.imgur.com/j2gJdIW.jpg',
    'https://i.imgur.com/3ssJ76r.jpg',
    'https://i.imgur.com/sqlcCqj.jpg',
    'https://i.imgur.com/eM3Qh3J.jpg',
    'https://i.imgur.com/Mi0aWU4.jpg',
    'https://i.imgur.com/iDnsnVF.jpg',
    'https://i.imgur.com/1Brpoqq.jpg',
    'https://i.imgur.com/j3NJ8tl.png',
    'https://i.imgur.com/I3AD7Zo.jpg',
    'https://i.imgur.com/udYqvvt.jpg',
    'https://i.imgur.com/Fsl7sNE.jpg',
    'https://i.imgur.com/MtHZ5Fn.jpg',
    'https://i.imgur.com/MzleBAj.jpg',
    'https://i.imgur.com/44ElLBa.png',
    'https://i.imgur.com/fQEvyK1.jpg',
    'https://i.imgur.com/CTOFw1d.jpg',
    'https://i.imgur.com/zXthutd.jpg',
    'https://i.imgur.com/uoJrYYQ.jpg',
    'https://i.imgur.com/u7pzHcA.jpg',
    'https://i.imgur.com/vtJ1sUk.jpg',
    'https://i.imgur.com/sJN6Qaq.jpg',
    'https://i.imgur.com/V3Vh3WB.jpg',
    'https://i.imgur.com/lXer95d.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CarouselSlider.builder(
              itemCount: urlImages.length,
              itemBuilder: (context, index, realIndex) {
                final urlImage = urlImages[index];
                return buildImage(urlImage, index);
              },
              options: CarouselOptions(
                autoPlay: true,
                height: 200,
                onPageChanged: (index, reason) => setState(() {
                  activeIndex = index;
                }),
              )),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildIndicator(),
          ),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Ang UP Sandiwa Samahang Bulakenyo ay isang varsitarian oganization ng itinatag noong 1994. ",
              style: TextStyle(fontFamily: 'Inter', fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Preambulo",
            style: GoogleFonts.patrickHandSc(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Kami, ang mga mag-aaral ng Unibersidad ng Pilipinas mula sa Bulacan, na nagbubuklod upang mapataas ang kamalayan ukol sa usaping panlipunan tungo sa makabuluhang pagkilos at paglilingkod, ay taos-pusong nagpapatibay at nagpapahayag ng Saligang Batas na ito.",
              style: TextStyle(fontFamily: 'Inter', fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
          Image.asset('assets/icons/sandiwa_logo.png', width: 250),
          Text(
            "Mga Simbolo",
            style: GoogleFonts.patrickHandSc(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          BulletList2(const [
            [
              "Tatsulok na Tatlong Magkakapatong na Kawayan",
              " - Ito ay sumisimbulo sa tatlong republika na naitatag sa Bulacan: Republika ng Biak-na-Bato, Republika ng Kakarong de Sili, at Republika ng Malolos."
            ],
            [
              "Dahon ng Laurel",
              " - Ito ay sumisimbolo sa husay ni Francisco 'Balagtas' Baltazar bilang makata at isa sa kinikilalang personalidad sa Bulacan. Ito rin ay sumisimbolo sa tagumpay."
            ],
            [
              "'UPS' at 'SANDIWA'",
              " - Ito ay sumasagisag sa pangalan ng organisasyon, UP SANDIWA SAMAHANG BULAKENYO."
            ],
            [
              "Araw",
              " - Ito ay sumasagisag sa pagkakabilang ng Bulacan sa walong lalawigan na unang nag-aklas laban sa pananakop ng mga Kastila."
            ],
            [
              "Lampara, pluma, at papel",
              " - Ito ay sumisimbolo sa kagalingang pang-akademiko."
            ],
            [
              "Puno ng Alibangbang",
              " - Ito ay sumisimbolo sa pagiging makakalikasan."
            ],
            ["Tao", " - Ito ay sumisimbolo sa lakas-paggawa at pagkakaisa."],
            [
              "1994",
              " - Ito ay sumisimbolo sa taon ng pagkakatatag ng UP SANDIWA SAMAHANG BULAKENYO, Setyembre 1, 1994."
            ],
          ]),
          const SizedBox(height: 15),
          Text(
            "Mga Kulay",
            style: GoogleFonts.patrickHandSc(fontSize: 24),
            textAlign: TextAlign.start,
          ),
          BulletList2(const [
            ["Luntian", " - Sumasagisag sa kalikasan at pag-asa."],
            ["Dilaw", " - Sumasagisag sa karunungan."],
            ["Pula", " - Sumasagisag sa damdaming makabayan."],
            [
              "Itim",
              " - Gagamitin ang kulay na ito sa sagisag kung hindi lalagyan ng mga naunang kulay."
            ],
          ]),
        ],
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: urlImages.length,
        effect: const ExpandingDotsEffect(
            spacing: 4,
            dotWidth: 8,
            dotHeight: 8,
            activeDotColor: Colors.black),
      );
  Widget buildImage(String urlImage, int index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: ImageBuffer(
          height: double.infinity,
          width: double.infinity,
          photoURL: urlImage,
          fit: BoxFit.cover,
        ),
      );
}
