---
name: Pro Circuit Mobile
colors:
  surface: '#fbf9f9'
  surface-dim: '#dbdad9'
  surface-bright: '#fbf9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f3f3'
  surface-container: '#efeded'
  surface-container-high: '#e9e8e7'
  surface-container-highest: '#e3e2e2'
  on-surface: '#1b1c1c'
  on-surface-variant: '#404752'
  inverse-surface: '#303031'
  inverse-on-surface: '#f2f0f0'
  outline: '#707783'
  outline-variant: '#c0c7d4'
  surface-tint: '#0060a8'
  primary: '#005ea4'
  on-primary: '#ffffff'
  primary-container: '#0077ce'
  on-primary-container: '#fdfcff'
  inverse-primary: '#a2c9ff'
  secondary: '#005faf'
  on-secondary: '#ffffff'
  secondary-container: '#54a0fe'
  on-secondary-container: '#003567'
  tertiary: '#8f4a00'
  on-tertiary: '#ffffff'
  tertiary-container: '#b35e00'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d3e4ff'
  primary-fixed-dim: '#a2c9ff'
  on-primary-fixed: '#001c38'
  on-primary-fixed-variant: '#004881'
  secondary-fixed: '#d4e3ff'
  secondary-fixed-dim: '#a5c8ff'
  on-secondary-fixed: '#001c3a'
  on-secondary-fixed-variant: '#004786'
  tertiary-fixed: '#ffdcc4'
  tertiary-fixed-dim: '#ffb780'
  on-tertiary-fixed: '#2f1400'
  on-tertiary-fixed-variant: '#6f3800'
  background: '#fbf9f9'
  on-background: '#1b1c1c'
  surface-variant: '#e3e2e2'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin-mobile: 16px
---

## Brand & Style
The design system focuses on a high-utility, professional eSports environment. The personality is "Athletic Corporate"—it treats gaming as a serious professional sport rather than a sci-fi fantasy. The UI prioritizes clarity, structural integrity, and ease of navigation to support competitive intensity without visual fatigue.

The aesthetic follows a **Modern Corporate** style. It leverages ample whitespace, a strict 8px grid system, and high-contrast typography to create a premium, production-ready feel. By eschewing typical gaming tropes like neons and dark modes, this design system establishes a trustworthy and sophisticated platform for organizers and players alike.

## Colors
The palette is rooted in a professional "True Blue" (#1E88E5). This primary blue is used for key actions and brand presence.

*   **Primary Blue:** Used for call-to-action buttons, active states, and focus indicators.
*   **Neutrals:** A range of cool greys is used for borders (#E0E0E0), secondary text (#757575), and primary body text (#212121).
*   **Backgrounds:** A pure white (#FFFFFF) is the standard canvas, with a subtle light grey (#F5F7F9) used for sectioning content or grouping list items.
*   **Semantic Colors:** Red and Green are used strictly for status (Win/Loss, Error/Success) and follow standard accessibility contrast ratios.

## Typography
This design system utilizes **Inter** for its exceptional legibility and neutral, modern tone. The hierarchy is strictly enforced to ensure users can scan tournament brackets and player stats quickly.

*   **Headlines:** Use SemiBold (600) or Bold (700) weights with slight negative letter-spacing to appear compact and impactful.
*   **Body Text:** Set at 16px for primary readability and 14px for secondary metadata. 
*   **Labels:** All-caps should be reserved for very small category labels (11px) to maintain a clean, professional aesthetic without looking aggressive.

## Layout & Spacing
The system is built on a **fixed 8px grid**. All margins and paddings must be multiples of 8 (e.g., 8, 16, 24, 32). 

*   **Mobile Screen Margins:** A standard 16px side margin is used for all views.
*   **Content Padding:** Use 16px for card internal padding and 8px for vertical spacing between related elements (like a label and its input).
*   **Stacking:** Groups of components (like a list of match cards) should be separated by 12px or 16px to maintain a dense but breathable information flow.

## Elevation & Depth
In line with a flat design philosophy, elevation is used sparingly to prevent the UI from feeling cluttered.

*   **Level 0 (Flat):** Used for the main background and input fields.
*   **Level 1 (Subtle Shadow):** Cards and primary buttons use a very soft shadow (0px 2px 4px rgba(0,0,0,0.05)) to separate them slightly from the background without creating a "floating" sci-fi effect.
*   **Dividers:** Use 1px solid lines (#EEEEEE) to separate list items or sections instead of using shadows to define boundaries.

## Shapes
A consistent 8px corner radius is applied to almost all interactive elements. This provides a modern, approachable feel while maintaining the structural "grid-like" look of a professional tool.

*   **Buttons & Inputs:** 8px radius.
*   **Cards:** 12px or 16px radius for larger surface areas.
*   **Avatars:** Circular (100% radius) for players; 4px radius for team logos to preserve their original design integrity.

## Components

### Buttons
*   **Primary:** Solid #1E88E5 background, White text, 8px radius. Height: 48px for mobile accessibility.
*   **Secondary:** White background with #1E88E5 border (1px), Blue text.
*   **Ghost:** Transparent background, Grey or Blue text, no border.

### Inputs & Forms
*   **Text Fields:** 1px #E0E0E0 border, 8px radius, 16px horizontal padding. On focus, the border changes to Primary Blue.
*   **Selection:** Checkboxes and Radios use the Primary Blue for active states.

### Cards
*   **Match Cards:** White background, Level 1 shadow, 16px padding. Scoreboards within cards use a subtle grey background (#F5F7F9) for the numbers to draw the eye.

### Navigation
*   **Bottom Bar:** Fixed white background with a 1px top border. Icons are 24x24px, thin-line style. Active state is indicated by the Primary Blue color.

### Tags & Chips
*   **Status Tags:** Small 4px radius chips with light tinted backgrounds (e.g., Light Green for "Live", Light Blue for "Upcoming") and darker text for high legibility.