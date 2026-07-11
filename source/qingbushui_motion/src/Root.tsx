import React from 'react';
import {Composition} from 'remotion';
import {QingWaterMotion} from './QingWaterMotion';

export const RemotionRoot: React.FC = () => {
  return (
    <Composition
      id="QingWaterMotion"
      component={QingWaterMotion}
      durationInFrames={150}
      fps={30}
      width={1080}
      height={1920}
      defaultProps={{}}
    />
  );
};
