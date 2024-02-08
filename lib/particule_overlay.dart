import 'dart:math';

import 'package:flutter/material.dart';
import 'package:particle_field/particle_field.dart';
import 'package:rnd/rnd.dart';

class ParticleOverlay extends StatelessWidget {
  const ParticleOverlay({super.key,required this.color,required this.energy});
final Color color;
final double energy;

  @override
  Widget build(BuildContext context) {
    return ParticleField(spriteSheet: SpriteSheet(image:AssetImage('assets/images/particle-wave.png'),
    ),
blendMode: BlendMode.dstIn,    
     onTick:(controller, _, size) {
       List<Particle>particles =controller.particles;
double a = rnd(pi*2);
double dist =rnd(1,4)*35+150*energy;
double vel = rnd(1,2)*(1+energy*1.8);
particles.add(Particle(
  lifespan: rnd(1,3)*20+energy*15,
  //starting dist from the center 
  x: cos(a)*dist,
y: sin(a)*dist,
//starting velocity
vx: cos(a)*vel,
vy: sin(a)*vel,
//other starting value 
rotation: a,
scale: rnd(1,2)*0.6+energy*0.5,
));
//update all of the particles
for(int i =particles.length - 1;i>=0;i--){
  Particle p = particles[i];
  if(p.lifespan<=0){
    particles.removeAt(i);
    continue;
  }
  p.update(
scale: p.scale*0.9,
vx: p.vx*0.9,
vy: p.vy*0.9,
color:color.withOpacity(p.lifespan*0.001+0.001),
lifespan: p.lifespan-1,
  );
}

     },);
  }
}