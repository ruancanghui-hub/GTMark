import React from 'react';
import {
  AbsoluteFill,
  Easing,
  interpolate,
  useCurrentFrame,
  useVideoConfig,
} from 'remotion';

const clamp = {
  extrapolateLeft: 'clamp' as const,
  extrapolateRight: 'clamp' as const,
};

export const QingWaterMotion: React.FC = () => {
  const frame = useCurrentFrame();
  const {fps} = useVideoConfig();

  const heroIn = interpolate(frame, [0, fps], [0, 1], {
    ...clamp,
    easing: Easing.bezier(0.16, 1, 0.3, 1),
  });
  const progress = interpolate(frame, [18, 72], [0, 0.6], clamp);
  const pulse = interpolate(frame, [75, 86, 100], [1, 1.08, 1], clamp);
  const slide = interpolate(frame, [96, 132], [0.28, 0.74], clamp);

  return (
    <AbsoluteFill
      style={{
        background:
          'linear-gradient(180deg, #2f96ff 0%, #8dcdff 34%, #eaf7ff 68%, #ffffff 100%)',
        fontFamily:
          'Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif',
        color: '#172033',
      }}
    >
      <div
        style={{
          padding: '118px 82px',
          height: '100%',
          boxSizing: 'border-box',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          gap: 42,
        }}
      >
        <div
          style={{
            alignSelf: 'stretch',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            opacity: heroIn,
            translate: `0 ${interpolate(heroIn, [0, 1], [-24, 0])}px`,
          }}
        >
          <div style={{display: 'flex', alignItems: 'center', gap: 24}}>
            <div
              style={{
                width: 82,
                height: 82,
                borderRadius: 41,
                background: '#ffffff',
                color: '#3d95f7',
                display: 'grid',
                placeItems: 'center',
                fontWeight: 900,
                fontSize: 48,
              }}
            >
              Q
            </div>
            <div style={{color: '#ffffff', fontWeight: 900, fontSize: 56}}>Qing Water</div>
          </div>
          <div
            style={{
              width: 82,
              height: 82,
              borderRadius: 41,
              background: 'rgba(255,255,255,0.28)',
              border: '2px solid rgba(255,255,255,0.42)',
            }}
          />
        </div>

        <div
          style={{
            width: '100%',
            height: 128,
            borderRadius: 64,
            background: '#ffffff',
            boxShadow: '0 28px 70px rgba(35,102,232,0.18)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            padding: '0 44px',
            boxSizing: 'border-box',
            opacity: heroIn,
            scale: interpolate(heroIn, [0, 1], [0.96, 1]),
          }}
        >
          <span style={{fontSize: 38, fontWeight: 800, color: '#aebdcd'}}>Daily goal</span>
          <span style={{fontSize: 40, fontWeight: 900, color: '#3d95f7'}}>60 oz</span>
        </div>

        <div
          style={{
            width: 520,
            height: 680,
            position: 'relative',
            opacity: heroIn,
            scale: interpolate(heroIn, [0, 1], [0.82, 1]),
          }}
        >
          <div
            style={{
              position: 'absolute',
              left: 120,
              right: 120,
              bottom: 30,
              height: 74,
              borderRadius: '50%',
              background: 'rgba(35,102,232,0.18)',
              filter: 'blur(16px)',
            }}
          />
          <div
            style={{
              position: 'absolute',
              left: 130,
              top: 42,
              width: 260,
              height: 580,
              borderRadius: 140,
              overflow: 'hidden',
              background: 'linear-gradient(135deg, #f1fdff, #67d8ff 45%, #2366e8)',
              boxShadow: 'inset 0 0 0 8px rgba(255,255,255,0.52), 0 30px 80px rgba(35,102,232,0.28)',
            }}
          >
            <div
              style={{
                position: 'absolute',
                left: 0,
                right: 0,
                bottom: 0,
                height: `${Math.round(progress * 100)}%`,
                background: 'linear-gradient(180deg, #8eeaff, #3d95f7 52%, #2366e8)',
                borderTopLeftRadius: 80,
                borderTopRightRadius: 80,
              }}
            />
            <div
              style={{
                position: 'absolute',
                left: 58,
                top: 110,
                width: 42,
                height: 210,
                borderRadius: 24,
                background: 'rgba(255,255,255,0.4)',
              }}
            />
            <div
              style={{
                position: 'absolute',
                left: 84,
                top: 282,
                width: 28,
                height: 28,
                borderRadius: 14,
                background: '#172033',
              }}
            />
            <div
              style={{
                position: 'absolute',
                right: 84,
                top: 282,
                width: 28,
                height: 28,
                borderRadius: 14,
                background: '#172033',
              }}
            />
          </div>
          <div
            style={{
              position: 'absolute',
              left: 182,
              top: 0,
              width: 156,
              height: 88,
              borderRadius: 44,
              background: '#beefff',
            }}
          />
        </div>

        <div
          style={{
            width: '100%',
            borderRadius: 72,
            background: 'linear-gradient(135deg, #62cbff, #3d95f7, #2366e8)',
            boxShadow: '0 34px 80px rgba(35,102,232,0.28)',
            padding: 48,
            boxSizing: 'border-box',
            color: '#ffffff',
            scale: pulse,
          }}
        >
          <div style={{fontSize: 68, fontWeight: 900}}>Hydrate gently</div>
          <div style={{fontSize: 38, fontWeight: 800, opacity: 0.84, marginTop: 12}}>36 / 60 oz</div>
          <div
            style={{
              marginTop: 34,
              height: 26,
              borderRadius: 999,
              background: 'rgba(255,255,255,0.22)',
              overflow: 'hidden',
            }}
          >
            <div
              style={{
                width: `${Math.round(slide * 100)}%`,
                height: '100%',
                borderRadius: 999,
                background: '#ffd66b',
              }}
            />
          </div>
        </div>
      </div>
    </AbsoluteFill>
  );
};
